/*
 * Copyright (C) 2014 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include "SurfaceManager.h"

#include "MirSurfaceItem.h"
#include "VirtualKeyboard.h"


SurfaceManager *SurfaceManager::the_surface_manager = nullptr;

SurfaceManager *SurfaceManager::singleton()
{
    if (!the_surface_manager) {
        the_surface_manager = new SurfaceManager();
    }
    return the_surface_manager;
}

SurfaceManager::SurfaceManager(QObject *parent) :
    QObject(parent)
    , m_virtualKeyboard(nullptr)
{
}

void SurfaceManager::registerSurface(MirSurfaceItem *surface)
{
    connect(surface, &MirSurfaceItem::inputMethodRequested,
            this, &SurfaceManager::showInputMethod);
    connect(surface, &MirSurfaceItem::inputMethodDismissed,
            this, &SurfaceManager::hideInputMethod);
    Q_EMIT surfaceCreated(surface);
}

void SurfaceManager::unregisterSurface(MirSurfaceItem *surface)
{
    disconnect(surface, 0, this, 0);
    Q_EMIT surfaceDestroyed(surface);
}

void SurfaceManager::showInputMethod()
{
    inputMethodSurface()->setState(MirSurfaceItem::Restored);
}

void SurfaceManager::hideInputMethod()
{
    if (m_virtualKeyboard) {
        m_virtualKeyboard->setState(MirSurfaceItem::Minimized);
    }
}

MirSurfaceItem *SurfaceManager::inputMethodSurface()
{
    if (!m_virtualKeyboard) {
        m_virtualKeyboard = new VirtualKeyboard(MirSurfaceItem::Minimized);
        Q_EMIT surfaceCreated(m_virtualKeyboard);
    }
    return m_virtualKeyboard;
}

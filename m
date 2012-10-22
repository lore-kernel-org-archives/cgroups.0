From: Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH 0/4] Rebase device_cgroup v2 patchset
Date: Mon, 22 Oct 2012 09:45:36 -0400
Message-ID: <20121022134536.172969567@napanee.usersys.redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>, cgroups@vger.kernel.org

This patchset rebases the v2 of the patchset since the v1 was pushed into -rc1
instead. The last patch, not present on previous patchset, fixes the
permission check when allowing everything in a cgroup.

 device_cgroup.c |   87 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 26 deletions(-)

Cc: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

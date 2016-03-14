From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] cgroup: avoid false positive gcc-6 warning
Date: Mon, 14 Mar 2016 23:36:05 +0100
Message-ID: <1457994978-1057495-1-git-send-email-arnd@arndb.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When all subsystems are disabled, gcc notices that cgroup_subsys_enabled_key
is a zero-length array and that any access to it must be out of bounds:

In file included from ../include/linux/cgroup.h:19:0,
                 from ../kernel/cgroup.c:31:
../kernel/cgroup.c: In function 'cgroup_add_cftypes':
../kernel/cgroup.c:261:53: error: array subscript is above array bounds [-Werror=array-bounds]
  return static_key_enabled(cgroup_subsys_enabled_key[ssid]);
                            ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
../include/linux/jump_label.h:271:40: note: in definition of macro 'static_key_enabled'
  static_key_count((struct static_key *)x) > 0;    \
                                        ^

We should never call the function in this particular case, so this is
not a bug. In order to silence the warning, this adds an explicit check
for the CGROUP_SUBSYS_COUNT==0 case.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 kernel/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 155c88470543..3348a36c3694 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -258,6 +258,9 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
  */
 static bool cgroup_ssid_enabled(int ssid)
 {
+	if (CGROUP_SUBSYS_COUNT == 0)
+		return 0;
+
 	return static_key_enabled(cgroup_subsys_enabled_key[ssid]);
 }
 
-- 
2.7.0

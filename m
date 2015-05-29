From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] cgroup: add seq_file forward declaration for struct cftype
Date: Fri, 29 May 2015 10:52:59 +0200
Message-ID: <8289624.GnpfIU6Era@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org

Recent header file changes for cgroup caused lots of warnings
about a missing struct seq_file form declaration for every
inclusion of include/linux/cgroup-defs.h.

As some files are built with -Werror, this leads to build
failure like:

                 from /git/arm-soc/drivers/gpu/drm/tilcdc/tilcdc_crtc.c:18:
/git/arm-soc/include/linux/cgroup-defs.h:354:25: error: 'struct seq_file' declared inside parameter list [-Werror]
cc1: all warnings being treated as errors
make[6]: *** [drivers/gpu/drm/tilcdc/tilcdc_crtc.o] Error 1

This patch adds the declaration, which resolves both the
warnings and the drm failure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b4a04ab7a37b ("cgroup: separate out include/linux/cgroup-defs.h")

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 7d83d7f73420..ab9dd741ab99 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -302,6 +302,8 @@ struct cgroup_root {
 	char name[MAX_CGROUP_ROOT_NAMELEN];
 };
 
+struct seq_file;
+
 /*
  * struct cftype: handler definitions for cgroup control files
  *

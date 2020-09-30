From: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: Zero sized write should be no-op
Date: Wed, 30 Sep 2020 19:42:42 +0300
Message-ID: <20200930164242.332249-1-jouni.roivas@tuxera.com>
References: <20200930163435.GB304403@tuxera.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200930163435.GB304403-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Do not report failure on zero sized writes, and handle them as no-op.

There's issues for example in case of writev() when there's iovec
containing zero buffer as a first one. It's expected writev() on below
example to successfully perform the write to specified writable cgroup
file expecting integer value, and to return 2. For now it's returning
value -1, and skipping the write:

	int writetest(int fd) {
	  const char *buf1 = "";
	  const char *buf2 = "1\n";
          struct iovec iov[2] = {
                { .iov_base = (void*)buf1, .iov_len = 0 },
                { .iov_base = (void*)buf2, .iov_len = 2 }
          };
	  return writev(fd, iov, 2);
	}

This patch fixes the issue by checking if there's nothing to write,
and handling the write as no-op by just returning 0.

Signed-off-by: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dd247747ec14..c26ba71c3d93 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3682,6 +3682,9 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	struct cgroup_subsys_state *css;
 	int ret;
 
+	if (!nbytes)
+		return 0;
+
 	/*
 	 * If namespaces are delegation boundaries, disallow writes to
 	 * files in an non-init namespace root from inside the namespace
-- 
2.25.1


From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.11 1/3] cgroup: mark "tasks" cgroup file as insane
Date: Mon, 3 Jun 2013 19:13:02 -0700
Message-ID: <20130604021302.GH29989@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
	:content-disposition:user-agent;
	bh=oFOlA7cyL8rMcA/GmLqpeZLsqQctii/htr6y6o5HScM=;
	b=LqSJkpX7uGX9vdCwQkrilJ7sl1/3GkV8uT5DJe+o3pnHqebdCkZdZI6KnbANtZKfD7
	0a/JvRKFjT9soQLadie9uuOLrFz86yUE92czVN2Hc0m03RlyvHJwobPc3bsuilJdC0Lt
	B8ofWH5Len3L1TYYZFUNEi/jS3esABQBR8O6xPHkgJtMhChmXgSoPBvEP8SIkrttDSgN
	YC6YjJlYaelhoLUQtpZ4ETLsHI0IfXWKVeZJUK+ei03+X83SIdn3zuM6uaXx80v4cka+
	6pijdYcSlgAPOQ17Eal68kQ6+DH8snW8ExEGl1zMBnqfGqz5VKDI6TPwS3azIbzM4lql
	QJSw==
Content-Disposition: inline
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Some resources controlled by cgroup aren't per-task and cgroup core
allowing threads of a single thread_group to be in different cgroups
forced memcg do explicitly find the group leader and use it.  This is
gonna be nasty when transitioning to unified hierarchy and in general
we don't want and won't support granularity finer than processes.

Mark "tasks" with CFTYPE_INSANE.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4037,6 +4037,7 @@ static int cgroup_clone_children_write(s
 static struct cftype files[] = {
 	{
 		.name = "tasks",
+		.flags = CFTYPE_INSANE,		/* use "procs" instead */
 		.open = cgroup_tasks_open,
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_pidlist_release,

From: "Pratik R. Sampat" <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [RFC 2/5] ns: Add scrambling functionality to CPU namespace
Date: Sat,  9 Oct 2021 20:42:40 +0530
Message-ID: <20211009151243.8825-3-psampat@linux.ibm.com>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wZMiLGZUzgEyouT+WJGGnMy3kyxoJ4X+fjWI2QClu/8=;
 b=KEwQzclcdEFCxe36Tu5haHseOMMjrWuMhOHkP2103CM0r0z+KPdpczO5n+8SBs41kgzk
 s+9qrJL+S7mxh85mhKPpBEevEovud+q6WZ6Zkio9tsiB3nEnMgROK84sn5uPiOXoY2s7
 mKgUo1epCOuU2mIomWZV7UNBazD/R35BW2kA76g9ftcum0KH7RKEWIcuGmBHrnuTAgno
 IJQzw87Nvzm+C7QzoqAACoV5j47XC+SB2mMmlBSGNP9NbQiRkDALahczd21X/SSXsSux
 rdjGVldyKfDSm7GW8hGNufsuNe/+Be4Zp3IR+BHiPdKaLK/4ikOIHGletX7mD/HrtF5i EQ== 
In-Reply-To: <20211009151243.8825-1-psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

The commit adds functionality to map every host CPU to a virtualized CPU
in the namespace.

Every CPU namespace apart from the init namespace has its CPU map
scrambled. The CPUs are mapped in a flat hierarchy. This means that
regardless of the parent-child hierarchy of the namespace, each
translation will map directly from the virtual namespace CPU to
physical CPU without the need of traversal along the hierarchy.

Signed-off-by: Pratik R. Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
 kernel/cpu_namespace.c | 49 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/kernel/cpu_namespace.c b/kernel/cpu_namespace.c
index 6c700522352a..7b8b28f3d0e7 100644
--- a/kernel/cpu_namespace.c
+++ b/kernel/cpu_namespace.c
@@ -27,6 +27,33 @@ static void destroy_cpu_namespace(struct cpu_namespace *ns)
 	put_user_ns(ns->user_ns);
 }
 
+/*
+ * Shuffle
+ * Arrange the N elements of ARRAY in random order.
+ * Only effective if N is much smaller than RAND_MAX;
+ * if this may not be the case, use a better random
+ * number generator. -- Ben Pfaff.
+ */
+#define RAND_MAX	32767
+void shuffle(int *array, size_t n)
+{
+	unsigned int rnd_num;
+	int i, j, t;
+
+	if (n <= 1)
+		return;
+
+	for (i = 0; i < n-1; i++) {
+		get_random_bytes(&rnd_num, sizeof(rnd_num));
+		rnd_num = rnd_num % RAND_MAX;
+
+		j = i + rnd_num / (RAND_MAX / (n - i) + 1);
+		t = array[j];
+		array[j] = array[i];
+		array[i] = t;
+	}
+}
+
 static struct ucounts *inc_cpu_namespaces(struct user_namespace *ns)
 {
 	return inc_ucount(ns, current_euid(), UCOUNT_CPU_NAMESPACES);
@@ -37,8 +64,9 @@ static struct cpu_namespace *create_cpu_namespace(struct user_namespace *user_ns
 {
 	struct cpu_namespace *ns;
 	struct ucounts *ucounts;
-	int err, i, cpu;
+	int err, i, cpu, n = 0;
 	cpumask_t temp;
+	int *cpu_arr;
 
 	err = -EINVAL;
 	if (!in_userns(parent_cpu_ns->user_ns, user_ns))
@@ -62,10 +90,21 @@ static struct cpu_namespace *create_cpu_namespace(struct user_namespace *user_ns
 	ns->parent = get_cpu_ns(parent_cpu_ns);
 	ns->user_ns = get_user_ns(user_ns);
 
-	for_each_present_cpu(cpu) {
-		ns->p_v_trans_map[cpu] = ns->parent->p_v_trans_map[cpu];
-		ns->v_p_trans_map[cpu] = ns->parent->v_p_trans_map[cpu];
+	cpu_arr = kmalloc_array(num_possible_cpus(), sizeof(int), GFP_KERNEL);
+	if (!cpu_arr)
+		goto out_free_ns;
+
+	for_each_possible_cpu(cpu) {
+		cpu_arr[n++] = cpu;
+	}
+
+	shuffle(cpu_arr, n);
+
+	for (i = 0; i < n; i++) {
+		ns->p_v_trans_map[i] = cpu_arr[i];
+		ns->v_p_trans_map[cpu_arr[i]] = i;
 	}
+
 	cpumask_clear(&temp);
 	cpumask_clear(&ns->v_cpuset_cpus);
 
@@ -80,6 +119,8 @@ static struct cpu_namespace *create_cpu_namespace(struct user_namespace *user_ns
 
 	set_cpus_allowed_ptr(current, &temp);
 
+	kfree(cpu_arr);
+
 	return ns;
 
 out_free_ns:
-- 
2.31.1


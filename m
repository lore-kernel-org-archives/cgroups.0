From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cpu/hotplug: wait for cpuset_hotplug_work to finish
 on cpu onlining
Date: Fri, 12 Feb 2021 14:41:58 -0500
Message-ID: <87tuqhrs3d.fsf@oracle.com>
References: <20210212003032.2037750-1-aklimov@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7l/HTcouzdCQubM+36EHWqvqjAfkWdgxqsZ9O6WgAtI=;
 b=GynNSQPPWRc4d7mYTUTMrlJCQR3amxCmINf4TcP5PoGWlchcIssENjWBGqNsviuICyRT
 yLkpItamXznEmHguU/7Dgn76uoQKE3HpNT48wUSyXv/ipTI+IpgK787KPut4lIGlXGv+
 qtdB+5VOf7Ah+bFodSvzpbcalLVtGdddVVX286XVoDGJrCRqGXpjljP7P5xGHhH3qhKm
 P754438qwbsL4iLfohqV33Xgu8QPL3fusqJnb9aBkN5pmBDCPa8JdXENNmFwGnsI8Xhn
 hOSM6GDyE5/T4BTdN+c7yw7byaricE8o0+uFzrgVJm0LtxkoYJOa3aRILKPCrwzzJ0Xs TQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7l/HTcouzdCQubM+36EHWqvqjAfkWdgxqsZ9O6WgAtI=;
 b=SlZjlqjskJ4z8Crkg8O39BU+A7q+Mbf6UbnSJ5Q00EuWaj2Rif4AHVO5r9hFrT0bW7JKBefVRqZE457DdYVQsYIopCBGk/poISX3KzXqjuQQ07HHbigzHVd1nA6H72qrDjehO6rFau47x2hhMple5Yb2iG14PlCQmTxuNLvS6+M=
In-Reply-To: <20210212003032.2037750-1-aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qais.yousef-5wv7dgnIgG8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> int cpu_device_up(struct device *dev)

Yeah, definitely better to do the wait here.

>  int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
>  {
> -	int cpu, ret = 0;
> +	struct device *dev;
> +	cpumask_var_t mask;
> +	int cpu, ret;
> +
> +	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
> +		return -ENOMEM;
>  
> +	ret = 0;
>  	cpu_maps_update_begin();
>  	for_each_online_cpu(cpu) {
>  		if (topology_is_primary_thread(cpu))
> @@ -2099,18 +2098,35 @@ int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
>  		 * called under the sysfs hotplug lock, so it is properly
>  		 * serialized against the regular offline usage.
>  		 */
> -		cpuhp_offline_cpu_device(cpu);
> +		dev = get_cpu_device(cpu);
> +		dev->offline = true;
> +
> +		cpumask_set_cpu(cpu, mask);
>  	}
>  	if (!ret)
>  		cpu_smt_control = ctrlval;
>  	cpu_maps_update_done();
> +
> +	/* Tell user space about the state changes */
> +	for_each_cpu(cpu, mask) {
> +		dev = get_cpu_device(cpu);
> +		kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> +	}
> +
> +	free_cpumask_var(mask);
>  	return ret;
>  }

Hrm, should the dev manipulation be kept in one place, something like
this?

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8817ccdc8e112..aa21219a7b7c4 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2085,11 +2085,20 @@ int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
 		ret = cpu_down_maps_locked(cpu, CPUHP_OFFLINE);
 		if (ret)
 			break;
+
+		cpumask_set_cpu(cpu, mask);
+	}
+	if (!ret)
+		cpu_smt_control = ctrlval;
+	cpu_maps_update_done();
+
+	/* Tell user space about the state changes */
+	for_each_cpu(cpu, mask) {
 		/*
-		 * As this needs to hold the cpu maps lock it's impossible
+		 * When the cpu maps lock was taken above it was impossible
 		 * to call device_offline() because that ends up calling
 		 * cpu_down() which takes cpu maps lock. cpu maps lock
-		 * needs to be held as this might race against in kernel
+		 * needed to be held as this might race against in kernel
 		 * abusers of the hotplug machinery (thermal management).
 		 *
 		 * So nothing would update device:offline state. That would
@@ -2100,16 +2109,6 @@ int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
 		 */
 		dev = get_cpu_device(cpu);
 		dev->offline = true;
-
-		cpumask_set_cpu(cpu, mask);
-	}
-	if (!ret)
-		cpu_smt_control = ctrlval;
-	cpu_maps_update_done();
-
-	/* Tell user space about the state changes */
-	for_each_cpu(cpu, mask) {
-		dev = get_cpu_device(cpu);
 		kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 	}
 
@@ -2136,9 +2135,6 @@ int cpuhp_smt_enable(void)
 		ret = _cpu_up(cpu, 0, CPUHP_ONLINE);
 		if (ret)
 			break;
-		/* See comment in cpuhp_smt_disable() */
-		dev = get_cpu_device(cpu);
-		dev->offline = false;
 
 		cpumask_set_cpu(cpu, mask);
 	}
@@ -2152,7 +2148,9 @@ int cpuhp_smt_enable(void)
 
 	/* Tell user space about the state changes */
 	for_each_cpu(cpu, mask) {
+		/* See comment in cpuhp_smt_disable() */
 		dev = get_cpu_device(cpu);
+		dev->offline = false;
 		kobject_uevent(&dev->kobj, KOBJ_ONLINE);
 	}
 

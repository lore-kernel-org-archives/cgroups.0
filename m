From: "John Wei" <johntwei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How cpu entitlement is calculated/enforce for cpu subgroup?
Date: Sun, 14 Sep 2014 17:51:05 -0700
Message-ID: <08a001cfd07f$2219bd90$664d38b0$@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:subject:date:message-id:mime-version:content-type
         :content-transfer-encoding:thread-index:content-language;
        bh=6BlGMpXbKlcXdXXvMcVgyc8thLuXy1nzbO3f+Ix//hU=;
        b=AYttqg9p2Y15TD1E++cgjB5HZHASdVE71H7otGrJHVLuBEskOGw2FNniZsJUCNLIxV
         NuaJ0gKYPmS2GjFqZ3mc43kEf3y7gjYbCnTqdK8UVMXCXLbZcX9WoV+oFBd/ZGCIknOD
         qHeruFxpT5XuRwAckfZuwPeXvBbOtmKlmGv7kqFQZDNwlCiFg4UEvfD6Tjly77mHyrVr
         WeaTcEil/to39SDBsubKs+4rVcM4rAS7QBw0mjsPoMyaBbFvCtFrbSJUon2+wXum3VdH
         JBGFcPBqrhghyWr9EuRUHhQWWSTj/Q/zEL8qYTPJxt9FldTOVPXM8UQxhI3KSoVyOcgt
         F0jg==
Content-Language: en-us
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'LKML-cgroups' <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I understand that CPU entitlement is based on cpu.share. If all the groups
are defined at first level, that is simple.
Once subgroups are defined, cgroups behave differently.
If you define cgroups hierarchy, then CPU entitlement is enforced base on
the cpu.share of "each" group and subgroup.
For example:
* group A has 1024 cpu.share
   Group A has two subgroup: A1, A2. Each has 1024 cpu.share
* group B has 1024 cpu.share
If you run process(es) in group, A, A1, A2, and, B. Each group and subgroups
get 25% of all the CPU.

Below is an example on defining cgroup hierarchy
Cpu = /cgroups/hierarchy
Cpuacct = /cgroup/hierarch
Memory = /cgroup/hierarch

If you do not define cgroup hierarchy, then cgroup treat A/A1/A2 as one
group and will get 50% CPU, and B will get 50% as well.
I can understand the reason why it is implemented this way. But, I don't
understand how cgroup divide that 50%  between A, A1, and A2.
During my testing, I found A1 and A2 received 10%, while the processes in
group A received about 30% CPU. All together, processes in A/A1/A2 received
about 50% CPU.

What is the formulate for this scenario? Is there a document for this.

John


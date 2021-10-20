From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Wed, 20 Oct 2021 06:35:32 -1000
Message-ID: <YXBFVCc61nCG5rto@slm.duckdns.org>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
 <a0f9ed06-1e5d-d3d0-21a5-710c8e27749c@linux.ibm.com>
 <YWirxCjschoRJQ14@slm.duckdns.org>
 <b5f8505c-38d5-af6f-0de7-4f9df7ae9b9b@linux.ibm.com>
 <YW2g73Lwmrhjg/sv@slm.duckdns.org>
 <77854748-081f-46c7-df51-357ca78b83b3@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rIB4RavRgXcRDUTdHan5IBjQWDQ5rtleRcIK4BBeq24=;
        b=Dq+l1NK7j0k2wEeaEka8PtuRkbWUI5me6x4H3y/NPBhOwrtkvjXZAjEaOas436KnV2
         gG6PMQIq1yCDlSpOFJqTbRwGuaHqi4NBsDeij5PHYLdqqBG1txBmVnnfuVsIEvwnW3ZL
         qV4y3xiXseZ/JGB+NIpZLTyRC+0SYpkFkFQDu9pRlQJrhNVLFwNxc6vczwNTmJb7dlf1
         thQOnjKhR83LyLLFoZcEUmCimKclCXoJmG0COBS+sVshkiAT7xs/NFgbk2kLf/zpiMBR
         JIfG2xgxuac+KpO0LVdJ9dvK8pMAr98ttvMLuRxIlJVLfUpkerbnLI0/q2Bxx4p6Rq9v
         X6qA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <77854748-081f-46c7-df51-357ca78b83b3-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pratik Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

On Wed, Oct 20, 2021 at 04:14:25PM +0530, Pratik Sampat wrote:
> As you have elucidated, it doesn't like an easy feat to
> define metrics like ballpark numbers as there are many variables
> involved.

Yeah, it gets tricky and we want to get the basics right from the get go.

> For the CPU example, cpusets control the resource space whereas
> period-quota control resource time. These seem like two vectors on
> different axes.
> Conveying these restrictions in one metric doesn't seem easy. Some
> container runtime convert the period-quota time dimension to X CPUs
> worth of runtime space dimension. However, we need to carefully model
> what a ballpark metric in this sense would be and provide clearer
> constraints as both of these restrictions can be active at a given
> point in time and can influence how something is run.

So, for CPU, the important functional number is the number of threads needed
to saturate available resources and that one is pretty easy. The other
metric would be the maximum available fractions of CPUs available to the
cgroup subtree if the cgroup stays saturating. This number is trickier as it
has to consider how much others are using but would be determined by the
smaller of what would be available through cpu.weight and cpu.max.

IO likely is in a similar boat. We can calculate metrics showing the
rbps/riops/wbps/wiops available to a given cgroup subtree. This would factor
in the limits from io.max and the resulting distribution from io.weight in
iocost's case (iocost will give a % number but we can translate that to
bps/iops numbers).

> Restrictions for memory are even more complicated to model as you have
> pointed out as well.

Yeah, this one is the most challenging.

Thanks.

-- 
tejun

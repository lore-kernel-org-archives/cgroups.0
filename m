From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Mon, 13 Jun 2016 21:29:32 +0000
Message-ID: <17cb1a37-47b1-dbd4-6835-efad3cf6c12f@gmail.com>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
 <20160613211227.GG31708@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=7htIqgYUsRp34UV1pu3+/ssDvqSkUb/Li01Tvg1M5EI=;
        b=DDh+x/7mPBYHX/0crVK03ao1dMBQwO+DEBQY2I8rj+ztBIRnmgTS4c/D5grEwkwXyC
         gqfr6z7U7cx2ZFqG25ybmrBrEURgjOAyLdtMb85gUghP6rAkGcHneRbz/sKE13wgoYEp
         sPaV7UQoa94dBE5z+bGax+QMsil9VzTiBqRc+m3bnHmPUv9TJD28tnsHiqHOb+sX1AwT
         IuKAFGPOeCqKaMuPLUrze0FzJPB2cnMdqfNzAzPSDruvInCONAY8kCwtkw6eA7Yt5wXQ
         xG9HrXX1hozjZOI8wf/otBfh07CM1mNh1C0lAl5izpbobDStCc3/dPm6+3YIFVDZg84n
         58Mw==
In-Reply-To: <20160613211227.GG31708-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 06/13/16 21:12, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jun 13, 2016 at 10:44:09PM +0300, Topi Miettinen wrote:
>> Track maximum pids in the cgroup, present it in cgroup pids.current_max.
> 
> "max" is often used for maximum limits in cgroup.  I think "watermark"
> or "high_watermark" would be a lot clearer.

OK, I have no preference.

> 
>> @@ -236,6 +246,14 @@ static void pids_free(struct task_struct *task)
>>  	pids_uncharge(pids, 1);
>>  }
>>  
>> +static void pids_fork(struct task_struct *task)
>> +{
>> +	struct pids_cgroup *pids = css_pids(task_css(task, pids_cgrp_id));
>> +
>> +	if (atomic64_read(&pids->cur_max) < atomic64_read(&pids->counter))
>> +		atomic64_set(&pids->cur_max, atomic64_read(&pids->counter));
>> +}
> 
> Wouldn't it make more sense to track high watermark from the charge
> functions instead?  I don't get why this requires a separate fork
> callback.  Also, racing atomic64_set's are racy.  The counter can end
> up with a lower number than it should be.
> 

I used fork callback as I don't want to lower the watermark in all cases
where the charge can be lowered, so I'd update the watermark only when
the fork really happens.

Is there a better way to compare and set? I don't think atomic_cmpxchg()
does what's needed,

>> @@ -300,6 +326,11 @@ static struct cftype pids_files[] = {
>>  		.read_s64 = pids_current_read,
>>  		.flags = CFTYPE_NOT_ON_ROOT,
>>  	},
>> +	{
>> +		.name = "current_max",
> 
> Please make this "high_watermark" field in pids.stats file.
> 
> Thanks.
> 

OK.

-Topi

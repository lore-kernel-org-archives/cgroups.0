From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Don't filter offline CPUs in
 cpuset_cpus_allowed() for top cpuset tasks
Date: Mon, 6 Feb 2023 10:17:05 -1000
Message-ID: <Y+FgQXvnzSF1OrmO@slm.duckdns.org>
References: <20230203164040.213437-1-longman@redhat.com>
 <Y94s8mzrE9VyUJLa@hirez.programming.kicks-ass.net>
 <f356b916-1c10-1565-73fb-34027c6c510a@redhat.com>
 <20230206110540.GA11024@willie-the-truck>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzNNQ1ME8UkUfRnNPhvhA1TlYJj5U9rDmc29+BCCEJo=;
        b=Ymr6rMkxUQI0TQbxkvW96Vlu8S7lxnyBnVAkQ3I1A5eZkuKKgVeMvNVHRPN0O/alpS
         LsKhELpnejK7pB3EnCJAaqimJEN2rYEr9s9aRaw+pSv43R5duOkhCUAozj+yXrh8A7qN
         mCvhxqvxaOtzGFL9DAU2sUPmk875fnMYPVpUP8Iffe3lAVdSRRDJnbZSAyMwsvM6JKFu
         k0mA/oFXmMnqweF9ulCFhXnz26DTw2SQbALC/TCAgpBs8mVM4+eeWdKznhHBolirtlfo
         ZptBNTpC1J56nyxdh+k6Qdx9ofk/rqC2ePrCQX6I/G0b0pVoLPGdF8MSCZgOYcBRFl1W
         4M/Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230206110540.GA11024@willie-the-truck>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

Hello,

On Mon, Feb 06, 2023 at 11:05:41AM +0000, Will Deacon wrote:
> > If we want to get it into the next merge windows, there isn't much time left
> > for linux-next testing. So a lower risk solution is better from that
> > perspective too.
> 
> This needs to land for 6.2 to fix the regression. The next merge window is
> too late. That's why I cooked the reverts [1] as an alternative.

Yeah, I think Waiman meant before the coming merge window. We have at least
one more week so let's try the two patches and see how that goes. We can
always revert if it doesn't work out.

Thanks.

-- 
tejun

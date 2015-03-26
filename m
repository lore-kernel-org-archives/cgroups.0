From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/3] cgroups: allow a cgroup subsystem to reject a fork
Date: Thu, 26 Mar 2015 11:08:06 -0400
Message-ID: <20150326150806.GB1953@htj.duckdns.org>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
 <1426307835-5893-3-git-send-email-cyphar@cyphar.com>
 <20150316165335.GC8353@htj.duckdns.org>
 <CAOviyagGvm4z8eAWitR267U3br-60vVJ9A5MMtFENy9xt9zuLQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hDGkkzFNK92Y0lCD2YEpX5/tTBCWNh8Tr1GuLYPjI+Y=;
        b=wQeZR98JLqdAnnPpGnUtTbKxIHHA5qFoJVbAxSdwWqWJNvyxExvAh+PQScUzpC7Man
         mivWnlwPrVUR2LHHkvNWj3ol/4B8utZ4KR00BDFqNDTlyfHDPWEAUxXyfzMG2q40u64m
         x+xlPCNnx4jlpACOaJEv1L28umKX/hC7I9rbKyNf8Ql7Ag9r4s+9DJD/8l51iM29Hirt
         TksNYRn2nKZmi7zR+V0NYe0eK257E5I2H5E37n5rf1RMtRkMO54i/vme4MgcUzUMPcM0
         e7Vuvkx03Mk/vY14pbN0fv/eQb0g5zB9EtHpwtTj7/2nsZkfmncIFcWWkq+jrb6PreZI
         A6GQ==
Content-Disposition: inline
In-Reply-To: <CAOviyagGvm4z8eAWitR267U3br-60vVJ9A5MMtFENy9xt9zuLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Mar 21, 2015 at 10:25:56PM +1100, Aleksa Sarai wrote:
> > Also, what pins the cset between task_css_set() and get_css_set()?
> > task_css_set() is protected by RCU and the above should have triggered
> > RCU warning if the debug option is enabled.  Please always test with
> > the debug options enabled, especially the lockdep and RCU ones.
> 
> Debug was enabled AFAIK and I didn't get anything in `dmesg`. I've fixed it
> anyway.

So, this is worrying.  If you have RCU debugging enabled, it should
have triggered the warning.  If it hadn't, maybe there's something
else protecting it and we don't need the extra rcu locking around it.
Can you please investigate what's going on?

Thanks.

-- 
tejun

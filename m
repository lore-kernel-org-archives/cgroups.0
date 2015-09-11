From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 22:09:48 +0530
Message-ID: <CAG53R5WTK8qWrL+CPJKuKHAsR31_E18rbny1PEfLQLqU5A9hEA@mail.gmail.com>
References: <20150908152340.GA13749@mtj.duckdns.org>
	<CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
	<20150910164946.GH8114@mtj.duckdns.org>
	<CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
	<20150910202210.GL8114@mtj.duckdns.org>
	<CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
	<20150911040413.GA18850@htj.duckdns.org>
	<55F25781.20308@redhat.com>
	<20150911145213.GQ8114@mtj.duckdns.org>
	<CAG53R5X5z-H15f1FzCFFqao=taYeHyJnXAZT2mPzAHYOkyq-_Q@mail.gmail.com>
	<20150911163449.GS8114@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=7Mq2yrunawxr6ZpwKNdgIRoSRb4hnWVPKGPngngeRXg=;
        b=s7okoCr6aROfz4+SZFTUhXhwV8z6gR6VofE8p2Ih/fMKZ3E0VpCMOIic6kLuggJOwh
         AitgYC34tTHyQmJj7sIi2qQ/c8PEAFpzgISXIDPT93I3CuxZeLlF4LVWAHFWWLpZLnyv
         ZcwQhvpwzSdOgAEnF0NcD0FCgYVGMnPbuwwCdRLtvPofjAKusQmqlmnnXgfQt++5BBYm
         2hpqZa7ggpowKFq7fvYJs8A7zjaRP7uRCubUTrxr2FPWVQb3AKgoFveRXKPSU6qxhvDN
         UaJFIZIWNv3j/2c9m0YsrTZTCOdp9lYyrfGQVXi1CF1QQdQB+zDsW9K+zomWhSOGiduS
         3XCQ==
In-Reply-To: <20150911163449.GS8114-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 11, 2015 at 10:04 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Fri, Sep 11, 2015 at 09:56:31PM +0530, Parav Pandit wrote:
>> Resource run away by application can lead to (a) kernel and (b) other
>> applications left out with no resources situation.
>
> Yeap, that this controller would be able to prevent to a reasonable
> extent.
>
>> Both the problems are the target of this patch set by accounting via cgroup.
>>
>> Performance contention can be resolved with higher level user space,
>> which will tune it.
>
> If individual applications are gonna be allowed to do that, what's to
> prevent them from jacking up their limits?
I should have been more explicit. I didnt mean the application to
control which is allocating it.
> So, I assume you're
> thinking of a central authority overseeing distribution and enforcing
> the policy through cgroups?
>
Exactly.



>> Threshold and fail counters are on the way in follow on patch.
>
> If you're planning on following what the existing memcg did in this
> area, it's unlikely to go well.  Would you mind sharing what you have
> on mind in the long term?  Where do you see this going?
>
At least current thoughts are: central entity authority monitors fail
count and new threashold count.
Fail count - as similar to other indicates how many time resource
failure occured
threshold count - indicates upto what this resource has gone upto in
usage. (application might not be able to poll on thousands of such
resources entries).
So based on fail count and threshold count, it can tune it further.




> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

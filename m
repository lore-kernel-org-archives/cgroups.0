From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/6] cgroup: update debug controller to print out thread
 mode information
Date: Wed, 19 Jul 2017 11:44:06 -0400
Message-ID: <20170719154406.GO3365493@devbig577.frc2.facebook.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-7-tj@kernel.org>
 <f6025fbf-bd53-dcd7-a5f7-d7e7a97da788@redhat.com>
 <20170719153105.GM3365493@devbig577.frc2.facebook.com>
 <c857861d-ac8c-9fe6-c8d2-c023dcc26809@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xxv/0vcG0Z0e0w/5TibpYaZWDAWh/JWTn8OiHshO5ro=;
        b=tnNBCo76N9FDbToG821HV1pAI2VE07JzGgeQ5Gc6j+nPqvR/ocTpZjhfJSTmvr3Pe/
         WKyqZus0Lvz4hILqOAucxAppeXiYCA1pGhw3Z9/xnjbdgRS6wAe9rcaZbyxpIfJk4ohO
         SyaV6uXGjzX6Kwxo8OSRV15ZU6Q3+tw7/Ycg1Lvu/8pYuGSnakhbCE9jNgK031U9GflI
         3bq1aU5yDS8ZQpQwD1NzSMrTZD5DVJXRrZkswuVNFueWXvZGPQS5JTQ9J4mtnnIDXRZz
         lQdGWXoYr+TphiHJ8BpejKLtHUAD8myfXXNfhLBNRSVLOSvvgLINZVbw78jXDggmETZu
         s+9A==
Content-Disposition: inline
In-Reply-To: <c857861d-ac8c-9fe6-c8d2-c023dcc26809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Wed, Jul 19, 2017 at 11:41:09AM -0400, Waiman Long wrote:
> On 07/19/2017 11:31 AM, Tejun Heo wrote:
> > Hello,
> >
> > On Mon, Jul 17, 2017 at 05:19:16PM -0400, Waiman Long wrote:
> >>> +	if (cgroup_is_thread_root(css->cgroup))
> >>> +		seq_puts(seq, "[thread root]\n");
> >>> +	else if (cgroup_is_threaded(css->cgroup))
> >>> +		seq_puts(seq, "[threaded]\n");
> >> The cgroup status will not be needed anymore as you have introduced the
> >> cgroup.type control file that returns the proper information.
> > Ah, right, will drop this file.
> >
> > Thanks.
> >
> Oh, I am not saying that we should drop the whole patch. I just want to
> drop the above 4 line of codes as they are not needed.

lol, yeah, that's me mis-writing.  I'm gonna drop only the duplicate
part.

Thanks.

-- 
tejun

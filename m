From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 3 Mar 2016 14:01:43 +0530
Message-ID: <CAG53R5WVdahjdJRy=AJ3T2uw45ZZA2sYWGnHxLANzX6g7JWtiA@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
	<CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
	<CAG53R5WcbE8Hesb2sh6xg1fRLBOBt+VFo0L3U6WLPr3irtko8w@mail.gmail.com>
	<56D7F27D.1040702@mellanox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=wDu1DjGjv+zO1M1Sw265qELcNND0NkfQhmVt3ji9jco=;
        b=AHyKV9Wnp6ToFNHvV+QF3eVCup0+1V3KMdtXcAJDgtFXm6QXsTFsl1e1FDg2MlWl1Q
         p559yikCXlIbxHacmY+MQL0IXiDN7uWClWc3gBXavSvGM89YdBbVLCVfAJ+nYkB9Mi5F
         JvUzRxIQBg1Eom5J5s+v1OWY5X3O0esB4Nu+l5VV0ZProPPniEP3tT7a0RtPIa66/6ZL
         /GJ/N7nMF/UrzbDvEOWLy6hdOi8QMUNm2IODoXGpRRb8x0tgnDqiDKVxVosSpkaNa6t9
         TUD6KcgewVpa//F+w6DPGveSv9IDRXr5IBJMhT+Nbnv+SRd0XcZdb0rCcUDPeK5wOpMw
         NRwQ==
In-Reply-To: <56D7F27D.1040702-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 3, 2016 at 1:44 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 03/03/2016 05:18, Parav Pandit wrote:
>> On Thu, Mar 3, 2016 at 1:28 AM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Wed, Mar 2, 2016 at 11:09 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>> Nothing seems to prevent @cg from going away if this races with
>>>> @current being migrated to a different cgroup.  Have you run this with
>>>> lockdep and rcu debugging enabled?  This should have triggered a
>>>> warning.
>> I am able to reproduce this race. Looking into how to address it.
>
> If I understand correctly, task_css() requires rcu read lock being held.
> Is task_get_css() suitable here?

Yes. Its suitable if we continue with newer API to drop "num" entries.
Or I will have make minor modification to support that in cgroup.h.
There is no variation as task_get_css_many, but its minor change anyway.
I saw slept off yesterday night, saw today morning.
Will test over weekend and wait for Tejun's opinion if there is any.

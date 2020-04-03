From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] docs: cgroup-v1: Document the cpuset_v2_mode mount
 option
Date: Fri, 3 Apr 2020 12:10:23 -0400
Message-ID: <1434c1e9-bc2d-f21e-a9a8-060c1812fc8e@redhat.com>
References: <20200330140615.25549-1-longman@redhat.com>
 <20200403154343.GE162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585930230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eP7ClUiEc6wxzyPpIfOZtYlk/BTjbvCUBAhRW9+z9Mo=;
        b=KISY7B6KF9UnK+isdnAurvtOU0HpzSqYfaX30O35CMC+k6u82VmBU14oozoerdR0cav/k2
        vNFgkSGNxo5DFb7/l7jLs00ErePfRS7kuKONvES619dSzyCaSWzEKOYZNLGM8t9+HYdKy5
        BqtBaqh9y2gcIH/0Liq+lfKtHc9Cvc8=
In-Reply-To: <20200403154343.GE162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 4/3/20 11:43 AM, Tejun Heo wrote:
> On Mon, Mar 30, 2020 at 10:06:15AM -0400, Waiman Long wrote:
>> The cpuset in cgroup v1 accepts a special "cpuset_v2_mode" mount
>> option that make cpuset.cpus and cpuset.mems behave more like those in
>> cgroup v2.  Document it to make other people more aware of this feature
>> that can be useful in some circumstances.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Applied to cgroup/for-5.7.
>
> Thanks.
>
Thanks,
Longman


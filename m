From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 21:26:51 -0400
Message-ID: <592d4120-0b42-4607-5efd-fb2d4d29f0cc@redhat.com>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org>
 <20200326194448.GA133524@google.com>
 <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
 <CAPz6YkVUsDz456z8-X2G_EDd-uet1rRNnh2sDUpdcoWp_fkDDw@mail.gmail.com>
 <20200326201649.GQ162390@mtj.duckdns.org>
 <20200326202340.GA146657@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585272420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUJ4EFBey4RnBsubrV8OieVsspJ5+/9YngaSQHIcXsM=;
        b=G5dS7ASBmByiPynkdns0cjjiamIfAXgpytnr0VBKI7LgddUM6hQBfc+/Cyp9TuZ/jLFzSV
        pbI9f4aCAy+1qqB2XLiUjENxmbIkKb5NE1F0oUtqlUhQBrrn3e1zIzsxu7GUyQ+KCOjHqW
        4SolYuBAT6FJzOr/A40sQgpPcSKi1wA=
In-Reply-To: <20200326202340.GA146657@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joel Fernandes <joel@joelfernandes.org>, Tejun Heo <tj@kernel.org>
Cc: Sonny Rao <sonnyrao@google.com>, linux-kernel@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>, Amit Pundir <amit.pundir@linaro.org>, kernel-team@android.com, Jesse Barnes <jsbarnes@google.com>, vpillai@digitalocean.com, Peter Zijlstra <peterz@infradead.org>, Guenter Roeck <groeck@chromium.org>, Greg Kerr <kerrnel@google.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>

On 3/26/20 4:23 PM, Joel Fernandes wrote:
> On Thu, Mar 26, 2020 at 04:18:59PM -0400, Tejun Heo wrote: >> On Thu, Mar 26, 2020 at 01:05:04PM -0700, Sonny Rao wrote: >>> I am
surprised if anyone actually wants this behavior, we (Chrome >>> OS) >>
>> The behavior is silly but consistent in that it doesn't allow empty
>> active cpusets and it has been like that for many many years now. >>
>>> found out about it accidentally, and then found that Android had >>>
been carrying a patch to fix it. And if it were a desirable >>> behavior
then why isn't it an option in v2? >> >> Nobody is saying it's a good
behavior (hence the change in cgroup2) >> and there are situations where
changing things like this is >> justifiable, but, here: >> >> * The
proposed change makes the interface inconsistent and does so >>
unconditionally on what is now a mostly legacy interface. >> >> * There
already is a newer version of the interface which includes >> the
desired behavior. >> >> * I forgot but as Waiman pointed out, you can
even opt-in to the >> new behavior, which is more comprehensive without
the >> inconsitencies, while staying on cgroup1. > > Thank you Tejun,
Waiman and Sonny. I confirmed the cgroup_v2_mode > option fixes cgroup
v1's broken behavior. > > We will use this mount option on our systems
to fix it.
I am glad that it works for you.

I think the problem is that the v2_mode mount option is not that well
documented. Maybe I should send a patch to add some some description
about it in cgroup-v2.rst or cgroup-v1/cpusets.rst.

Cheers,
Longman




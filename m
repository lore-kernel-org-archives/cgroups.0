From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 6/7] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 13 Dec 2021 11:00:17 -1000
Message-ID: <Ybe0YWEo7Wp7wib9@slm.duckdns.org>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-7-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WMxjO0tx6t02AbcQby54NPy8RyK3yOypDjZIab8vXh4=;
        b=f9xizRMo/j3PXqOZs5juMJcQ37RJ5hWQLM+DY21WpJeu9oIwrszgkESzp+5lzfcPu/
         S1xClURBIc1R5ZVu5ZUI/+iUkArHUMLGwuCCKqUaRzYwg5Avh7YpSAokVvTPS2Fl4yej
         QEpPj8HkBkveAgjGp1Uwvd74RkiIpvriZ0fL7nvbYk0KnZrMlg7CSDEyu3KP1tz1BuDs
         QfTGyB7tn/01WVnR0Fwv8cm0i1q2j9i7t0OAAPsgRMy/+EsZTeFoyqT/4Xo1TuvOAomL
         rtOobYElaG+HmdQnvhuS2kPRXEJ534YqBFGguvlzK1LZO2run0kelOEKRf4Yj3qIeeoE
         ar2g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211205183220.818872-7-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

On Sun, Dec 05, 2021 at 01:32:19PM -0500, Waiman Long wrote:
> +	In the case of an invalid partition root, a descriptive string on
> +	why the partition is invalid is included within parentheses.
> +
> +	Almost all possible state transitions among "member", valid
> +	and invalid partition roots are allowed except from "member"
> +	to invalid partition root.

So, this part still bothers me for the following two reasons that I brought
up earlier:

* When a valid partition turns invalid, now we have a reliable way of
  discovering what exactly caused the transition. However, when a user now
  fails to turn a member into partition, all they get is -EINVAL and there's
  no way to discover why it failed and the failure conditions that -EINVAL
  represents aren't simple.

* In an automated configuration scenarios, this operation mode may be
  difficult to make reliable and lead to sporadic failures which can be
  tricky to track down. The core problem is that whether a given operation
  succeeds or not may depend on external states (CPU on/offline) which may
  change asynchronously in a way that the configuring entity doesn't have
  any control over.

It's true that both are existing problems with the current partition
interface and given that this is a pretty spcialized feature, this can be
okay. Michal, what are your thoughts?

Thanks.

-- 
tejun

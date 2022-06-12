From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Sun, 12 Jun 2022 07:40:25 -1000
Message-ID: <YqYlCRywdgSYtwKk@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fCsuCKlg/4qaHi+wkVJiXx2JwHlxDYcAa4PfTMau5mk=;
        b=cgMM1H8/meNhom7TYkhnUbO7+ywI9qaWn0+oUXBXhwoqJdb5n6GMPVtq+V1AzVQj0v
         C54qYNCyOrZJROCG4BURbeDLwKAaZ7n2TlA0xUeK+urGdBztW8H90itoP1WMHAEGsnZS
         gtWyWD1zJwXj3GoUvkdTENQ7R1bR7fAPk9QfEsrsC2e/irIa0up3k38Q7qEb0Vt1l9a+
         iQgH9mVmXnI/n/+7jFz9sGr0tWi9NZ4nkTZ8iS3v1RvwG2cpHWsCgU632IAgo332SX/z
         YVEyoDs9+iOaeJHGsiOEbj1VrEv/oVXCnCUqDLxX3PrRu5ujfoxfn7mLs4O2xwjxG8Y4
         8kKQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220510153413.400020-4-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

Sorry about the long delay.

On Tue, May 10, 2022 at 11:34:08AM -0400, Waiman Long wrote:
> Once a partition with empty "cpuset.cpus.effective" is formed, no
> new task can be moved into it until "cpuset.cpus.effective" becomes
> non-empty.

This is always true due to no-tasks-in-intermediate-cgroups requirement,
right?

Thanks.

-- 
tejun

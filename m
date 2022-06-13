From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Sun, 12 Jun 2022 16:55:13 -1000
Message-ID: <YqanEZZooeZwtutA@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
 <YqYlCRywdgSYtwKk@slm.duckdns.org>
 <YqYlOQjKtQCBsQuT@slm.duckdns.org>
 <ce3106c1-a3c4-b449-bafc-6940d672bd94@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t63caDtqr0AA//ZoM6eXOV7nTgEroVQihZDmmTAtOVw=;
        b=SpagrkUXR/0al8kxNb16RlzUwSttPdjODwumZyEug/IOxk77Wn3Mi8YIPGQuBDv6L+
         lPnw5bIkZo9WIWVuvxnsjSvVEt0o/w2h1Keu5u96Alig1OhlrcF+ojdSI/rJ18fPQlY6
         j5580adTKoAazBnfc3pCQ9rgnGTtlEdteIEGIZrm9GX6xEnTDiJ/eXt83zzXQibzkvFB
         iVt8NUhYWbVqXm5CBAzcjQOHnnkhQa/50EzdPjrJu9q50uv7ZO6g1v9JwyNxeq4cJaNE
         9obhx4drondnrlUNw+oYqt7+JVVSuSIhjwy/DN5JzDKAMdIvNGfsXGytooH4DpRDAQP1
         kFlA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ce3106c1-a3c4-b449-bafc-6940d672bd94@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

On Sun, Jun 12, 2022 at 10:53:53PM -0400, Waiman Long wrote:
> Without this patch, cpus.effective will never be empty. It just falls back
> to its parent if it becomes empty. Now with an empty cpus.effective, I am

Yeah, that part is fine.

> afraid that if a task is somehow moved to such a cpuset, something bad may
> happen. So I add this check as a safeguard.

But how would that happen? A lot of other things would break too if that
were to happen.

Thanks.

-- 
tejun

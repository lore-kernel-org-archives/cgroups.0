From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 25 Aug 2021 09:24:25 -1000
Message-ID: <YSaY6SbKMD2b3Oec@slm.duckdns.org>
References: <20210814205743.3039-1-longman@redhat.com>
 <20210814205743.3039-6-longman@redhat.com>
 <YRqbj5+ZdS+7k0Fn@slm.duckdns.org>
 <95b72d36-32a9-8356-05b7-2829e4cc29ad@redhat.com>
 <YSVCv0WjTzwPUWUN@slm.duckdns.org>
 <af7ad628-62f4-848b-7eaa-1c9eb62355b6@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:84;0;0cto;
        bh=PGxtjBFxPgG3Jd9Zpl37bDstSoJ0Gj+kNpbO5xi0BEw=;
        b=SqsbO1EwGVFKKZI4L7H6CKN1OWwR+R4V6j6RZ/XwrfaNg7tatBfXGORpM/dsXhuRWX
         1gGcpWO7f4fzfSW3sYTHcJzW74XYyF/lnRct3FlyvJdYRLeERW2cbhTE0121qCKQhbkO
         j7cUUVCjDL+r+QJMGc2QBnOeQwaVJ1fwStUtZWPCRkJLYsxEG1Dp8np9JLU5bnFM7d7n
         JMkhwIhU48DZ9uOPs5cIaW6cr8mIltTcfJ+woL5GfhljTDGhcYWcRo2CWIeqOs5u4FKh
         9LH75bTT9EP48nvcrzlGn1TH5wICzP5ov/p/cyLPTf8oZ1yMh/9k78X3Zi1L4UjoNDm7
         T0+g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <af7ad628-62f4-848b-7eaa-1c9eb62355b6@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>

Hello,

On Wed, Aug 25, 2021 at 03:21:59PM -0400, Waiman Long wrote:
> I agree that the current description is probably more complicated than it
> should be. I will try to fix that.

To avoid repeating back-and-forth with all the code changes, would it help
if you first describe the intended behaviors whether that's in the form of
doc patch or just informal description?

Thank you.

-- 
tejun

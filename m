From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 3/4] mm: memcontrol: re-use node VM page state enum
Date: Thu, 6 Apr 2017 11:59:58 +0300
Message-ID: <20170406085958.GC2268@esperanza>
References: <20170404220148.28338-1-hannes@cmpxchg.org>
 <20170404220148.28338-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=edMVlhawanCjy2b5nV8N6mXDDdEGrVUeCq3TfVeNzjA=;
        b=IJW/2HTPbipLRqnSDTQWPHKAgWrv6dNxSjEQyLLevOjhNM8eJrt5Vp8xwEIqh9SzMl
         wGNfRI/sxnhPb5KSgS0WE3QIDo6xR479phqxzibp1iTYZZDeMtMnov2lFd5mbSpHpJ3D
         EAC3/8fmSJR3vQUTuAoNyvvogYjdKhOlOh6gbU7SYLmEClK3HVQWdSwZwj2ItMagKszi
         5u5H4Ru+YRUv56gB0KcVgAA0ZZYj6pURVSM5+3a03eSaMBuPKV5ZAWPl6cVJbLJgxiDr
         lLXcQtWAZAHBKj/ssOPrWQ1N+heoQS95L24SU7YzlTyIFo0XjwAj1hHhCvVxZ2UNpxG8
         Gpnw==
Content-Disposition: inline
In-Reply-To: <20170404220148.28338-3-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Apr 04, 2017 at 06:01:47PM -0400, Johannes Weiner wrote:
> The current duplication is a high-maintenance mess, and it's painful
> to add new items or query memcg state from the rest of the VM.
> 
> This increases the size of the stat array marginally, but we should
> aim to track all these stats on a per-cgroup level anyway.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

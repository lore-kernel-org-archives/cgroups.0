From: Tejun Heo <tj@kernel.org>
Subject: Re: [v10 5/6] mm, oom: add cgroup v2 mount option for cgroup-aware
 OOM killer
Date: Thu, 5 Oct 2017 08:51:38 -0700
Message-ID: <20171005155138.GU3301751@devbig577.frc2.facebook.com>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-6-guro@fb.com>
 <20171004200453.GE1501@cmpxchg.org>
 <20171005131419.4o6qynsl2qxomekb@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RJ3Go8mHz7z9xTLdv0yz7K4u5ajafb5/sowj3zuk4aw=;
        b=AbSDSc6RGrY+TarXvgv/DMb/HlakDUk5a/zAyPtUT/vpl61nnsdTujMybyzxUIlaw7
         k0vPs6XnF1FKS7ULrOeh8IURx7pvXZ2kCTz6j4Ka9+kqZmdGU6Fcx9PhFjZUjEoBY8yo
         1WnZxEijmr2zDP96AABDFoDxgOGOB/RXLIRQCJWWpGomhurj5pfHYj5e6ZfFmb8kuNHD
         sMWYsFEhjWtLBugBOx1NvFa/VDKCkVMx/XZz1m7x0//RyGmypOS0IhXqOexzl4NgJYqZ
         gnN71WHIoe8vlm4SQXrguZVzeFYIlpM64IbDOgd6S5LPRJXt6eVKNoOko6DoAp9w4vzp
         gZCg==
Content-Disposition: inline
In-Reply-To: <20171005131419.4o6qynsl2qxomekb@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Oct 05, 2017 at 03:14:19PM +0200, Michal Hocko wrote:
> Yes and that is why I think a boot time knob would be the most simple
> way. It will also open doors for more oom policies in future which I
> believe come sooner or later.

While boot params are fine for development and debugging, as a
user-interface, they aren't great.

* The user can't easily confirm whether the config they input is
  correct and when they get it wrong what's wrong can be pretty
  mysterious.

* While kernel params can be made r/w through /proc, people usually
  don't expect that and using that can become really confusing because
  a lot of people use "dmesg|grep" to confirm the boot params and that
  won't agree with the setting written later.

* It can't be scoped.  What if we want to choose different policies
  per delegated subtree?

* Boot params aren't the easiest (again, if you're a developer,
  they're but most aren't developers) to play with and prone to cause
  deployment issues.

* In this case, even worse because it ends up silently ignoring a
  clearly explicit configuration in an interface file.

If the behavior differences we get from group oom code isn't critical
(and it doesn't seem to be), I'd greatly prefer just enabling it when
cgroup2 is in use.  If it absolutely must be opt-in even on cgroup2,
we can discuss other ways but I'd really like to see stronger
rationales before going that route.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

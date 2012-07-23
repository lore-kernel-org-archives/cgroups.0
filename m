From: Ying Han <yinghan@google.com>
Subject: Re: [PATCH] fix bad behavior in use_hierarchy file
Date: Mon, 23 Jul 2012 10:22:03 -0700
Message-ID: <CALWz4ixg5YYt6Np4zqO0Yn+U6vEGRRoGQoDmt8A1Vc5zwD91dQ@mail.gmail.com>
References: <1340616061-1955-1-git-send-email-glommer@parallels.com>
	<20120625204908.GL3869@google.com>
	<20120626075653.GD6713@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=imj1OqM38K1H6wqSaqn2rQOvCGOXsXUNJ5z7g/SgD/0=;
        b=B+N+CbH0+G9mX5aEXDSItcu5B+JqUzREVqyItfZ5Kq8tJO2Ca7NDknInCA560k53wP
         7jNOwgs2j/EVtr6+BytIqA2ShHYj/0LBP8jsi0Lf/CTKaHwGLpDXfA+zvHknFbf8NySt
         w4ZnBlzswkYDvr0jQ9y5mzRafo4myekUQ9xCir37PjftGsw3Y3sWNa0nYhmoNGWUS1yX
         sRXajsVEn+LsB6snRrga6zFYWYZ8b3ps4SmrlnLffNJw15WypZ7dy4WeHqXgYKBpjKXo
         BGk+HP6617JupqlGZucxTUTKUnaFN5hyASGoZ846QRA1vlUGDbz7FJvmcSx+a65/rZjh
         fGwA==
In-Reply-To: <20120626075653.GD6713@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org, Dhaval Giani <dhaval.giani@gmail.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>

On Tue, Jun 26, 2012 at 12:56 AM, Michal Hocko <mhocko@suse.cz> wrote:
> [Adding Ying to CC - they are using hierarchies AFAIU in their workloads]

Sorry for late ( a month late ) to the thread.

Our current production today doesn't support multi-hierarchy setup for
memcg, and all the cgroups are flat under root at least on the memory
resource perspective. However, we do have use_hierarchy set to 1 to
root cgroup upfront.

On the other hand, we started exploring nested cgroup since the flat
configuration doesn't fullfill all our usecases. In that case, we will
have configurations like: root-> A -> B -> C ( not sure about C but at
least level to B). Of course, we will have use_hierarchy set to 1 on
each level, and the mixed setting won't happen AFAIK.

--Ying
>
> On Mon 25-06-12 13:49:08, Tejun Heo wrote:
> [...]
>> A bit of delta but is there any chance we can either deprecate
>> .use_hierarhcy or at least make it global toggle instead of subtree
>> thing?
>
> So what you are proposing is to have all subtrees of the root either
> hierarchical or not, right?
>
>> This seems needlessly complicated. :(
>
> Toggle wouldn't help much I am afraid. We would still have to
> distinguish (non)hierarchical cases. And I am not sure we can make
> everything hierarchical easily.
> Most users (from my experience) ignored use_hierarchy for some reasons
> and the end results might be really unexpected for them if they used
> deeper subtrees (which might be needed due to combination with other
> controller(s)).
> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

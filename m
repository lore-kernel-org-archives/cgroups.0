From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/12] cfq-iosched: implement cfq_group->nr_active and
 ->level_weight
Date: Mon, 17 Dec 2012 13:15:17 -0800
Message-ID: <20121217211517.GC1844@htj.dyndns.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-7-git-send-email-tj@kernel.org>
 <20121217204609.GH7235@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kWoESnuTDhOIb8ZWQfIpg+ikxPonIzM2/aH4ELpB/Lw=;
        b=FACdrStbrXFVjGqloDprGqboyE1sBuurUmUdds8mguVqb5Aa39lvLoLnA8H0WCDSqE
         mWwwJBp4cL2dt6xpyolJ/m3475MR0RnzxfW+oJuD845En1PDelP6dZvsypC1Pw7WQTdr
         ug+vGEvWTL5kLXgMg3vk1pCNDkcYaooiaqSncEr//+65XywRewrhrv3m/iEoK+mjmXO7
         SnB8DyAp0KpDROebEtqHuyCoY+PIteifbUW7KQyg4kqX2IQtrNMJf06mCCwLnVObfDjn
         wIAdOSBxpP5JENLfcBzik5uHGyZb892JbACJvdrxBufBU0cUCab5yLG0kIKChKdOfs43
         Apeg==
Content-Disposition: inline
In-Reply-To: <20121217204609.GH7235-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello, Vivek.

On Mon, Dec 17, 2012 at 03:46:09PM -0500, Vivek Goyal wrote:
> On Fri, Dec 14, 2012 at 02:41:19PM -0800, Tejun Heo wrote:
> > To prepare for blkcg hierarchy support, add cfqg->nr_active and
> > ->level_weight.  cfqg->nr_active counts the number of active cfqgs at
> > the cfqg's level and ->level_weight is sum of weights of those cfqgs.
> > The level covers itself (cfqg->leaf_weight) and immediate children.
> 
> This notion of level is really confusing. If one says "at cfqg's level"
> I immediately associate with cfqg's siblings and not with cfqg's children.

We can explicitly say at children's level but I think it should be
enough to explain it clearly in the comment where the field is
defined.

> I think confusion happens because we are overloading the definition of
> cfqg. It is competing with its siblings at the same time it is competing
> against its child groups (on behalf of its children tasks).

While I agree that part is a bit tricky, I can't think of a much
better way to describe it.  Any better ideas?

Thanks.

-- 
tejun

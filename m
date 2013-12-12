From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: fix missing unlock on error in
 cgroup_load_subsys()
Date: Thu, 12 Dec 2013 10:46:26 -0500
Message-ID: <20131212154626.GE32683@htj.dyndns.org>
References: <CAPgLHd8s94-e2=tynt-jKKNmoSXzNFHs+vYeUS1uW3+Ohk_OVA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kJnOuMEXlOXIzy2kPhdHERmFoE3iaNt1SdbpNBG/MlA=;
        b=MahzA4djPZkXWMZvMHv6pbwKFxXW/LJCJPlLIRs2OXiqFOxBkurYQvixtrYBJEHOlO
         NJtEaokxh9QauBzefOeQ0qQCMne0YRiaNAS7PGKTiL0Q1kH7UA87PRoREP+XJydgn5fS
         zXnbInYGxiIk+j2SgdVo0njnrhSzh9f5rFNFeKwwsvUiNpBreBvvpbSsV9gxZXr7MA1b
         uvFMqORTNjV3abqTEwuh9HqJ++F9sJZ44qWUp9l7qiiVp5IAwQXaZdDngMiTmbW4eo9C
         eHex6i91hlNJj42UxPKsYWC6I+1Vpmf2xGXkBpN43yNoFL1kx023vuwGpKZI46sspWJS
         PHsw==
Content-Disposition: inline
In-Reply-To: <CAPgLHd8s94-e2=tynt-jKKNmoSXzNFHs+vYeUS1uW3+Ohk_OVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 09, 2013 at 08:38:29PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> 
> Add the missing unlock before return from function cgroup_load_subsys()
> in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Applied to cgroup/for-3.14.

Thanks.

-- 
tejun

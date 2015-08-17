From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-4.3] cgroup,memcg: generalize event
 handling and enable notifications on "memory.events"
Date: Mon, 17 Aug 2015 17:32:09 -0400
Message-ID: <20150817213209.GM21075@mtj.duckdns.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
 <20150817212920.GA29138@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GxGU8uZK+nViRkg+2pe5XhKXh+nnb9rgW2CV08iVfnw=;
        b=I8I15/HsSSKBRjWYUF8mCN7rV6K/hcTm6z9KyKlZ5iFE7u1dpNp6Ivqda1pdot5LXQ
         rzgvXQIKWkxcmPszRIdatXBSnQczW/CtTvfLbQ+oD+tqf6Fcrm51HCeIQxb1389h1wt4
         IglLNJhZFM4P+MDULpca6Pih3RKbjo7cYuDz/u3gozJ1JOzn3xpE8Uw3JLJzMcKO+Ja7
         fedAj+zKDTHw6PWTZrJAaNdvQr5KWSqO8BnixB0aiCx9LH2fS+UDXpQlGOPkXVR+C7To
         fSiwfsGEFXOTT3JWvY0Vj+2BgDOAQnTqo2IWhjkk66nKP1MI98PbN+109JAsvHidvBhQ
         VZOw==
Content-Disposition: inline
In-Reply-To: <20150817212920.GA29138-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Aug 17, 2015 at 11:29:20PM +0200, Johannes Weiner wrote:
> Out of curiosity, do you envision additional entries for cgroup.events
> in the near future?

I don't have anything specific I can think of right now.  I primarily
want to establish interface convention regarding low-frequency event
delivery and memory.events's seemed simple and extensible.

Thanks.

-- 
tejun

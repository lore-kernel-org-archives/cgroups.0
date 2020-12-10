From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RESEND PATCH v2 01/12] mm: memcontrol: fix NR_ANON_THPS account
Date: Thu, 10 Dec 2020 17:02:14 +0100
Message-ID: <20201210160214.GG264602@cmpxchg.org>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-2-songmuchun@bytedance.com>
 <20201210160045.GF264602@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Uj7y3A8V2AwfLN+Pqn8MEopt38Al+RWbGM3+oeOM5I=;
        b=C1AKu65PSoE7zQcCNy0JQRQoNgwkUc0P9zhgctECcKh2D2QvnaGL/kiQGLaAUPEWaf
         ORRPEgv7zEwgBlOYKCoVem69+rPqrnkmdBRJTX9zh7pZS/K+n5f0RtDYbXvWCUp0JRpo
         0wXQoSNA4pBGbpwJHKw6jX94wupKYKqYIe4yRh5fGSGwsyg0pIAwgOZeNPYdzmtWrckV
         N14VPhHIRFwm7QftCfbb0M16p+2BInbAx6gHoZkqXnWuG3zEExM2DTEP4aA5k8V3ydJa
         O4ze2uJfmUW6B2iTyHyVzbAn2dQt6f22d3RxlIZqOO6F5ZWBz65O3UvSHF0zV+vhT95C
         Wr3Q==
Content-Disposition: inline
In-Reply-To: <20201210160045.GF264602@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Thu, Dec 10, 2020 at 05:00:47PM +0100, Johannes Weiner wrote:
> On Sun, Dec 06, 2020 at 06:14:40PM +0800, Muchun Song wrote:
> > The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
> > by one rather than nr_pages.
> 
> This is a real bug, thanks for catching it.
> 
> However, your patch changes the user-visible output of /proc/vmstat!
> 
> NR_ANON_THPS isn't just used by memcg, it's a generic accounting item
> of the memory subsystem. See this from the Fixes:-patch:
> 
> -                       __inc_node_page_state(page, NR_ANON_THPS);
> +                       __inc_lruvec_page_state(page, NR_ANON_THPS);
> 
> While we've considered /proc/vmstat less official than other files
> like meminfo, and have in the past freely added and removed items,
> changing the unit of an existing one is not going to work.

Argh, I hit send instead of cancel after noticing that I misread your
patch completely. Scratch what I wrote above.

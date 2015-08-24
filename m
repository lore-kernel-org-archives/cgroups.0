From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroup: pids: fix invalid get/put usage
Date: Mon, 24 Aug 2015 15:00:37 -0400
Message-ID: <20150824190037.GC28944@mtj.duckdns.org>
References: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
 <1440335432-4202-1-git-send-email-cyphar@cyphar.com>
 <1440335432-4202-3-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cxzLz0harXllLXvh2zHO+e3N3P/0ef8BayHklKrD2tc=;
        b=Bi67MFUWuqsuakOr/2gjELNR56J5UNcPujpGQ9fw9iwwgm4Bo8F92qrzCAJnUT+iaY
         +6FF2jl7kHe0QU9PjxQxpQAEh+xtE4NoNLnLBJ/tt41iZowIpRIivCLLPie3fKxY1r8S
         dDuKHHMtXRThVL3V0RkyFLWiQrdCaFA5I01vawaOi7QwliiIim/SIUcXMJf/BmQ6nKRt
         tzI8QrKCnlD16Ia4afl+IignTf1xY6cWNWk0m7/gXIoNXXx2C6VRN45CzThByFPGN2if
         2qmKpWk8UucM1OrGuOa2lXeNxXnUsT7uaDxXdJDJE78n7J55kFLlRVCwlWI4XFziOqsF
         Svxg==
Content-Disposition: inline
In-Reply-To: <1440335432-4202-3-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Sun, Aug 23, 2015 at 11:10:32PM +1000, Aleksa Sarai wrote:
> Fix incorrect usage of css_get and css_put to put a different css in
> pids_{cancel_,}attach() than the one grabbed in pids_can_attach(). This
> could lead to quite serious memory leakage (and unsafe operations on the
> putted css).

So, this patch looks correct to me but can you update the description
so that it notes that the source css doesn't go away while migration
is in progress and thus pinning is unnecessary to begin with?

Thanks.

-- 
tejun

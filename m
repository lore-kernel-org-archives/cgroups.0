From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH] docs: cgroup-v1: wrap charge moving deprecation in
 warning block
Date: Fri, 20 Jan 2023 15:20:51 +0700
Message-ID: <2c19bec4-c4e7-7ac4-d612-27e531b1a022@gmail.com>
References: <20230106034836.23708-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TWumMt67h30adlz6lQSPu1lCC0nb5fEUVVbRzQpjcvo=;
        b=XBjIbyJ7l70xuIKKldJeINNaWQ8MoXJ2Y/IACHV3SKahghX1ofznCaFuqGW1pcNIrS
         /mQX+uH0K7q9Z85U4Zg0+Nhfh9kvQVske4+pMpxH4+noV2FZqhlur1tMARaScb7+swgL
         HP+ymXJohkaaOYNcvpqPxkFjADs7X2By3yuHk3nFAMRciZQP25ZKFHIi79Nzc8Q+sVN7
         /Q2vJvKvy3qgGoi5RquanqEymtWxjCpnToEuU0rIlItKIRSRrLnwjoceRgGbiPKtyY8h
         e7/hrk2T+i2IJfhBSHY1R++kGn+FX0Bhttu1kx/RuUDEPTse+DyMk6Fq8qa6EQC39VoW
         Fz5A==
Content-Language: en-US
In-Reply-To: <20230106034836.23708-1-bagasdotme@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>

On 1/6/23 10:48, Bagas Sanjaya wrote:
> Commit 4ddb1a2aa1a3c4 ("docs: cgroup-v1: wrap remaining admonitions in
> admonition blocks") in cgroups tree states that it also wraps charge
> moving deprecation notice in admonition block (specifically warning).
> However, the notice isn't in cgroups tree when the v2 of formatting
> improv series [1] is submitted (and then applied), but rather in mm tree
> instead.
> 
> Wrap the notice to fulfill the intention of referred commit.
> 

Ping?

-- 
An old man doll... just what I always wanted! - Clara


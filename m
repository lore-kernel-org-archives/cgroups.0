From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/9] docs: cgroup-v1: formatting improv for "Memory
 Resource Controller" doc
Date: Thu, 5 Jan 2023 07:39:01 -1000
Message-ID: <Y7cLNTlazRghuxoy@slm.duckdns.org>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AnT3159KFsCJ48uEVH/264Q/p+zAUBME0hFPZg68eg=;
        b=T9iSn5FzZm2l6Viva4kX8AvyD/WH9zRn2pTLbOVeXmWhVoEA3zpe9CRAuPUy4dHkYO
         NSEHuZBHhD7KkKwFEfQ813/AlSTenvi1RJG1FcbvgbZ+7ZUQNUnO0rRYOHeSbGu7N0Jz
         zX5irW0PrakMdmoGO8/byqY6133m/OW/YjIjk8fvB3BXE2hQzzZH31EP4UcUT9NLJO+y
         VsxxhttA20KpNwTY8Y1df+pY11APnUzx7R8kAUFT6FFTWMRmotpMQ9CPxn3/McTfkyRW
         09CG7J9+RCQCT5mE0j9mlUzE+YZ+/rtBM+aToJXX/NN4hXZV1PtSUTF21KLFAJQ1s97h
         Wi0g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230105131633.553574-1-bagasdotme@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>

On Thu, Jan 05, 2023 at 08:16:25PM +0700, Bagas Sanjaya wrote:
> "Memory Resource Controller" CGroup v1 documentation has been in reST since
> 99c8b231ae6c6c ("docs: cgroup-v1: convert docs to ReST and rename to *.rst").
> The current doc look is kinda ugly, so improve the formatting (only htmldocs is
> tested).

Applied to cgroup/for-6.2-fixes.

Thanks.

-- 
tejun

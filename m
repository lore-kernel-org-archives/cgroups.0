From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm, docs: update memory.stat description with
 workingset* entries
Date: Mon, 15 May 2017 09:56:37 -0400
Message-ID: <20170515135637.GB24783@cmpxchg.org>
References: <1494530293-31236-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UWvIhJf6r0DB3Fet0lGJ4lbg7YEpw+Em2+ZLtZxuE88=; b=bsoGmCEQNeJq+WWHKhCr8Kabr7
        Sl9s8UD7uGfnh0TcfQAH8XJ1qjSawXCLt8qg5go7yN2zVQJEC0NiEgrBeYC64+GYry68yXM+e/w0Z
        9WVgzdTLndTtScjY0Ys8Y9f1ABgS707bUrrTXZiZ5DrWzCYmoHOYosanVHEcx2a6dgxA=;
Content-Disposition: inline
In-Reply-To: <1494530293-31236-1-git-send-email-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, May 11, 2017 at 08:18:13PM +0100, Roman Gushchin wrote:
> Commit 4b4cea91691d ("mm: vmscan: fix IO/refault regression in
> cache workingset transition") introduced three new entries in memory
> stat file:
>      - workingset_refault,
>      - workingset_activate,
>      - workingset_nodereclaim.
> 
> This commit adds a corresponding description to the cgroup v2 docs.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Roman!

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 08/10] sched/psi: consolidate cgroup_psi()
Date: Wed, 24 Aug 2022 06:19:46 -0400
Message-ID: <YwX7QvIpmPpxEHgI@cmpxchg.org>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-9-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=s0j2FSbwvmjKdvN+169nQdScgb7ALVuRcy3EIVLP7So=;
        b=DNYaMoJZfqTl1zDi6NfKZZNWYwlrnOiVUiJmcwR/S17jsY9fY/Ngvx8ghbhYAQYLBZ
         iosJQQDlAc2g+gT/jZ08h5QB8fcv4B7NVl0dzILk2YtT5fwGcE742npl8exZOAzm+0nu
         Gwl5Vid27xtbN7GAblRedWuh/ys90QXaZZvu+xQG6IAGfMTgGMhEc560XEWHesJI/Rn7
         crl2l5Bcu1/NXTW+J9mMKFiWXjfZGppPM3A0EvsLASxxnw3/XvZ1IZs2+glf+3Xczq1v
         7O/VRL7UEObRyKjXpOjb8Zi01VJ7UFfV02Bc6L/TKGpYLA8hihsJUgMZTgRx340ziDDD
         2Apg==
Content-Disposition: inline
In-Reply-To: <20220824081829.33748-9-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: tj@kernel.org, mkoutny@suse.com, surenb@google.com, gregkh@linuxfoundation.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 24, 2022 at 04:18:27PM +0800, Chengming Zhou wrote:
> cgroup_psi() can't return psi_group for root cgroup, so we have many
> open code "psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi".
> 
> This patch move cgroup_psi() definition to <linux/psi.h>, in which
> we can return psi_system for root cgroup, so can handle all cgroups.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

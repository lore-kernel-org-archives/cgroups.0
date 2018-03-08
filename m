From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: memcg: expose mem_cgroup_put API
Date: Thu, 8 Mar 2018 15:40:58 -0800
Message-ID: <20180308154058.9158c9c1ff1e4e67990bcce7@linux-foundation.org>
References: <20180308024850.39737-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308024850.39737-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Wed,  7 Mar 2018 18:48:50 -0800 Shakeel Butt <shakeelb@google.com> wrote:

> This patch exports mem_cgroup_put API to put the refcnt of the memory
> cgroup.

Not the best of changelogs :(

Why is this patch being added?

It's a prerequisite for <I-forget-which-patch> isn't it?



From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation/memcg: update kmem limit doc as codes
 behavior
Date: Sat, 14 May 2016 10:13:13 -0600
Message-ID: <20160514101313.34fde503@lwn.net>
References: <572B0105.50503@huawei.com>
	<20160505083221.GD4386@dhcp22.suse.cz>
	<5732CC23.2060101@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5732CC23.2060101@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Qiang Huang <h.huangqiang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>, tj@kernel.org, Zefan Li <lizefan@huawei.com>, hannes@cmpxchg.org, akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Wed, 11 May 2016 14:07:31 +0800
Qiang Huang <h.huangqiang@huawei.com> wrote:

> The restriction of kmem setting is not there anymore because the
> accounting is enabled by default even in the cgroup v1 - see
> b313aeee2509 ("mm: memcontrol: enable kmem accounting for all
> cgroups in the legacy hierarchy").
> 
> Update docs accordingly.

Applied to the docs tree, thanks.

jon

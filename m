From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH -mm] slab: use cgroup ino for naming per memcg caches
Date: Wed, 8 Apr 2015 13:24:26 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504081323390.20694@gentwo.org>
References: <1428414798-12932-1-git-send-email-vdavydov@parallels.com> <20150407133819.993be7a53a3aa16311aba1f5@linux-foundation.org> <20150408095404.GC10286@esperanza> <alpine.DEB.2.11.1504080845200.13120@gentwo.org> <20150408181911.GA18199@esperanza>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150408181911.GA18199@esperanza>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
	s=q20140121; t=1428517468;
	bh=/4QdF8nnxZaL4HUU8hvrNd9Tyar3Uz15/8pesE/y1jk=;
	h=Received:Received:Received:Received:Date:From:To:Subject:
	 Message-ID:Content-Type;
	b=tgXS/KidYek/Xx+7iV6awRnz7oXk6tt6x7QzFqM8IchIsM5HFHExOAVe4qiZ1gkMX
	 iU6rW4o4svgJ/lWF5Fl2iV1ERmCzaEhZiPS9jSLht8XbmCmQg8EnJsB4F4/UX2WO9Y
	 1SzPL7n6/K/iZ1PogqpUwGl+SC4lz4x1IGv6x3eLxIevj4ucTwygDezhK/hK9N4PHE
	 OA30SuzshEorty6VzRWjze52LRuYdfWBzTX4QPOGUnRxn5fLMJb2JQocvORZXTF9sm
	 Zz4CXzOTpWCuI1XmcSsiZVBMHu8AZjR+uRAnO8wz+5sqLdALlIrAoiQf5WYty9TMdL
	 cjy41XKSc8TbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 8 Apr 2015, Vladimir Davydov wrote:

> Yeah, I think cache merging is a good argument for grouping memcg caches
> under /sys/kernel/slab/<slab-name>/cgroup/. We cannot maintain symlinks
> for merged memcg caches, because when a memcg cache is created we do not
> have names of caches the new cache is merged with. If memcg caches were
> listed under /sys/kernel/slab/ along with global ones, absence of the
> symlinks would lead to confusion.

The point of the unique name creation is to not have to use the name given
by the user for the slab. You can generate a unique identifier and use
that as a target for the symlink.


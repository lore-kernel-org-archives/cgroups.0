From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 1/2] mm: multigen-LRU: working set reporting
Date: Wed, 10 May 2023 10:25:54 +0200
Message-ID: <2023051016-snarl-fame-9d6b@gregkh>
References: <20230509185419.1088297-1-yuanchu@google.com>
 <20230509185419.1088297-2-yuanchu@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org 3553460FF1
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp3.osuosl.org B723860F81
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org 760EC41F85
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org C5DBD41F81
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1683707156;
 bh=yyuOZPHJUbcP9aRarpv4MRiXOkJWXGAGGyeBIlMq4nc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=0LiSIdWiydHsjiJsZ54H/qYkl8uWEKUlPA1USETAuz4e/hFVQ+Ekx7+/+fUO6lZ8u
 +hp8e+zrKfDfaeUa/gyx6wqCtOsUIwF5TKHQLHhrUvCHv23cDbUCpr3sFqNXY606RL
 WwUdqKEAeBMjRJRVVFULAWqg/156NVs9dBQo2dLY=
Content-Disposition: inline
In-Reply-To: <20230509185419.1088297-2-yuanchu@google.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>, 
 <mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Errors-To: virtualization-bounces@lists.linux-foundation.org
Sender: "Virtualization" <virtualization-bounces@lists.linux-foundation.org>
To: Yuanchu Xie <yuanchu@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org, kai.huang@intel.com, hch@lst.de, Yu Zhao <yuzhao@google.com>, Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, talumbau <talumbau@google.com>, "Sudarshan Rajagopalan (QUIC)" <quic_sudaraja@quicinc.com>, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, virtualization@lists.linux-foundation.org, jon@nutanix.com, SeongJae Park <sj@kernel.org>, Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>

On Wed, May 10, 2023 at 02:54:18AM +0800, Yuanchu Xie wrote:
> From: talumbau <talumbau@google.com>

Please fix the name here.

> 
> A single patch to be broken up into multiple patches.

What does this mean?

> - Add working set reporting structure.
> - Add per-node and per-memcg interfaces for working set reporting.
> - Implement working set backend for MGLRU.

Please break it up to be reviewable, otherwise no one will review it.

thanks,

greg k-h

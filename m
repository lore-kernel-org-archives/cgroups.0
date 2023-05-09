From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH 2/2] virtio-balloon: Add Working Set reporting
Date: Tue, 9 May 2023 16:50:53 -0400
Message-ID: <20230509164528-mutt-send-email-mst@kernel.org>
References: <20230509185419.1088297-1-yuanchu@google.com>
 <20230509185419.1088297-3-yuanchu@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org 838BF4294C
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp4.osuosl.org C1DBB42940
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.osuosl.org BFBBC8470B
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.osuosl.org 88C7E846FB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1683665466;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=PNiIZHyonT4Lc3v22Wd8EHVvgd0ES2GAsHIl3w6taTA=;
 b=SAeTk2ThdripM3HdxcC30tK7PwUcp+Rw8rfp994YqkwTknrFGGy55qc+B6CDulQxBBraq7
 JMCAcMLt50Dw+KYBqcYFv3bYl8ae5KxJOs1LHFBhLuzJjfz4Wf9VacYVYam/jt4kJNdEw2
 vVmWTvO2TrtQLmxXsFuILzflnu9kbBw=
In-Reply-To: <20230509185419.1088297-3-yuanchu@google.com>
Content-Disposition: inline
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
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org, kai.huang@intel.com, hch@lst.de, Yu Zhao <yuzhao@google.com>, Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, talumbau <talumbau@google.com>, "Sudarshan Rajagopalan (QUIC)" <quic_sudaraja@quicinc.com>, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, virtualization@lists.linux-foundation.org, jon@nutanix.com, SeongJae Park <sj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>

On Wed, May 10, 2023 at 02:54:19AM +0800, Yuanchu Xie wrote:
> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> index ddaa45e723c4..06d0683d8d8c 100644
> --- a/include/uapi/linux/virtio_balloon.h
> +++ b/include/uapi/linux/virtio_balloon.h

Any changes to this have to be documented in the virtio spec
and be sent to virtio TC.

> @@ -37,6 +37,7 @@
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
>  #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
>  #define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
> +#define VIRTIO_BALLOON_F_WS_REPORTING 6 /* Working Set Size reporting */
>  
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
> @@ -59,6 +60,8 @@ struct virtio_balloon_config {
>  	};
>  	/* Stores PAGE_POISON if page poisoning is in use */
>  	__le32 poison_val;
> +	/* Number of bins for Working Set report if in use. */
> +	__le32 ws_num_bins;

working_set_ pls. eschew abbreviation.
Really __le32? Is 4G bins reasonable? what if it's 0?

>  };
>  
>  #define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped in */
> @@ -116,4 +119,22 @@ struct virtio_balloon_stat {
>  	__virtio64 val;
>  } __attribute__((packed));
>  
> +enum virtio_balloon_ws_op {
> +	VIRTIO_BALLOON_WS_REQUEST = 1,
> +	VIRTIO_BALLOON_WS_CONFIG = 2,
> +};


what's this?

> +
> +struct virtio_balloon_ws {

document fields.

> +#define VIRTIO_BALLOON_WS_RECLAIMABLE 0
> +#define VIRTIO_BALLOON_WS_DISCARDABLE 1

what are these?

> +	/* TODO: Provide additional detail on memory, e.g. reclaimable. */

Well? If we don't now hypervisors will come to depend on
this being broken.

> +	__virtio16 tag;
> +	/* TODO: Support per-NUMA node reports. */

Same. This is ABI we can't merge with unaddressed TODO items.

> +	__virtio16 node_id;
> +	uint8_t reserved[4];
> +	__virtio64 idle_age_ms;
> +	/* Track separately for ANON_AND_FILE. */

What does this mean?

> +	__virtio64 memory_size_bytes[2];




> +};
> +
>  #endif /* _LINUX_VIRTIO_BALLOON_H */

Use LE for new features please.

-- 
MST

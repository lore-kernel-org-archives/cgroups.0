From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v10 3/8] hugetlb_cgroup: add reservation accounting for
 private mappings
Date: Fri, 17 Jan 2020 14:57:59 -0800
Message-ID: <49e5872e-eecb-4279-bc79-bbc1e132ab5d@oracle.com>
References: <20200115012651.228058-1-almasrymina@google.com>
 <20200115012651.228058-3-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dENVIhtYjj5QMBF4ot0Yq+caEuhMLKWT5Dd/N2rM48Q=;
 b=gfQ9AU6+gFr7y+gwnYkF8lpRjg5PLqyA3gj5zD9hId1KspjMU2Vx8gwUJ1p3n6HAEN3N
 mJrQsow7Q/z1eMRpRsi8yi2K4Rx1DTHIuyOCOZFYuz6xQIeS/CtKH+rWkZt0Ap+ZyipQ
 92sVO1yRWntXwMduKdKil5ZR/e9p0XUrEjaeMbOqw65mJjnFZm2/2OL+89ozjumAI0g6
 D2AauVFhe5N44zxIJhOcMBBnF4csmL4QQHVgbD7NRnpUjL+5gVAV/NGYsjJyS2jua0il
 bKVUKko9VCpxkUBGLORM/tQ3p6W1L47IOY/Yw4ql/4cPy1y9A7CetvIWKNyuDEvUur87 2A== 
In-Reply-To: <20200115012651.228058-3-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, rientjes@google.com, shakeelb@google.com
Cc: shuah@kernel.org, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com

On 1/14/20 5:26 PM, Mina Almasry wrote:
> Normally the pointer to the cgroup to uncharge hangs off the struct
> page, and gets queried when it's time to free the page. With
> hugetlb_cgroup reservations, this is not possible. Because it's possible
> for a page to be reserved by one task and actually faulted in by another
> task.
> 
> The best place to put the hugetlb_cgroup pointer to uncharge for
> reservations is in the resv_map. But, because the resv_map has different
> semantics for private and shared mappings, the code patch to
> charge/uncharge shared and private mappings is different. This patch
> implements charging and uncharging for private mappings.
> 
> For private mappings, the counter to uncharge is in
> resv_map->reservation_counter. On initializing the resv_map this is set
> to NULL. On reservation of a region in private mapping, the tasks
> hugetlb_cgroup is charged and the hugetlb_cgroup is placed is
> resv_map->reservation_counter.
> 
> On hugetlb_vm_op_close, we uncharge resv_map->reservation_counter.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz

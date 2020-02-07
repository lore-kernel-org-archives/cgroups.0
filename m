From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v11 6/9] hugetlb_cgroup: support noreserve mappings
Date: Fri, 7 Feb 2020 10:16:43 -0800
Message-ID: <ac89801a-1285-78df-9baf-3404054b89cb@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-6-almasrymina@google.com>
 <6cc406e7-757f-4922-ffc0-681df3ee0d18@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0uBr6XR4Zt4xjOg6S4oT3byCfbBlkldYwrJH52Ta7Js=;
 b=gvq3fnqtPy4SDQK/z/Li3x6am80Pjk6AWjfElg0ENzzjRZwvMt5UZLeeJf9+aI+wgQ9H
 n+lJUUsk+l0Gf/PyBbK0bkuH2BLIxVEF2G+XMS4sm6tpyhFsdPlNPbj0hcNBl4cggSNW
 oMMP9dXjJGxTfVGGXDygPOvGJGNxT7Ym/oObUcfN1uziFiXqwxIKeNtzPeA4MvQ2phTX
 LQiGonZVOVcKLzX5JcIgzulR+NpcciwZ9IgYb14DsbZcloD3tGvcJ5AT2bkuRKyOtXug
 pdidOABPrktDUZtHi6IjuLTRXrMkCyaJImLD34Fxt/tXod6qPw/kpSnW9jN79xXs/qOD 8g== 
In-Reply-To: <6cc406e7-757f-4922-ffc0-681df3ee0d18@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On 2/6/20 2:31 PM, Mike Kravetz wrote:
> On 2/3/20 3:22 PM, Mina Almasry wrote:
>> Support MAP_NORESERVE accounting as part of the new counter.
>>
>> For each hugepage allocation, at allocation time we check if there is
>> a reservation for this allocation or not. If there is a reservation for
>> this allocation, then this allocation was charged at reservation time,
>> and we don't re-account it. If there is no reserevation for this
>> allocation, we charge the appropriate hugetlb_cgroup.
>>
>> The hugetlb_cgroup to uncharge for this allocation is stored in
>> page[3].private. We use new APIs added in an earlier patch to set this
>> pointer.
> 
> Ah!  That reminded me to look at the migration code.  Turns out that none
> of the existing cgroup information (page[2]) is being migrated today.  That
> is a bug. :(  I'll confirm and fix in a patch separate from this series.
> We will need to make sure that new information added by this series in page[3]
> is also migrated.  That would be in an earlier patch where the use of the
> field is introduced.

My appologies!

cgroup information is migrated and you took care of it for new reservation
information in patch 2.  Please disregard that statement.

-- 
Mike Kravetz

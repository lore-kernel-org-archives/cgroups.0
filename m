From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v12 2/9] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Fri, 14 Feb 2020 16:50:25 -0800
Message-ID: <791880db-bdb0-8d34-ea9a-be6e4996fc0d@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-2-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=O1PJ+4+ziITIIDCQTVcIjvVNxViqJQWUnTHw+Th26V8=;
 b=VXZRxTZQ2qgIBBqwFKH5ijK5H99sawjGv5ald0By6jX1Lyxvfz1CSEpnTKO9TShUc4rp
 Fdi7ymZp/8MLDbLW2oOwyfGP0SahHyWAz92R/QHuRAr0c0YnEYA3eTzqLGH/dj4oP1oZ
 JohC9KPdlZ5EO5xstF2wwWW2Q3oFRhj4wXenabQyba1lf2h+TCbBJ9XIlPv2NT36HyG/
 Q8Rw9N49X+QgjyPPJl2vjWzBeD/8tSnw9fGmxB0+bj7nZ4iOQTeoLJ0f5cI3MQ0pv1Qy
 FSX/vBG8atTSoS3+yvp1A7W6hpcnNYiJyNtSU6StqUmoVPZtOr67iRIMMR/qJjFOOj7q 0A== 
In-Reply-To: <20200211213128.73302-2-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On 2/11/20 1:31 PM, Mina Almasry wrote:
> Augments hugetlb_cgroup_charge_cgroup to be able to charge hugetlb
> usage or hugetlb reservation counter.
> 
> Adds a new interface to uncharge a hugetlb_cgroup counter via
> hugetlb_cgroup_uncharge_counter.
> 
> Integrates the counter with hugetlb_cgroup, via hugetlb_cgroup_init,
> hugetlb_cgroup_have_usage, and hugetlb_cgroup_css_offline.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 

Thanks for the suggested changes.  It will make the code easier to
read and understand.

Acked-by: Mike Kravetz <mike.kravetz@oracle.com

> ---
> 
> Changes in v12:
> - Instead of true/false param for rsvd or non-rsvd calls, now there is:
> hugetlb_cgroup_*() call for non-rsvd
> hugetlb_cgroup_*_rsvd() call for rsvd
> __hugetlb_cgroup_*(, bool) for both.
> - Removed review tags as this patch changed quite a bit.

From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v12 2/9] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Sat, 15 Feb 2020 17:21:48 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2002151720540.244463@chino.kir.corp.google.com>
References: <20200211213128.73302-1-almasrymina@google.com> <20200211213128.73302-2-almasrymina@google.com> <791880db-bdb0-8d34-ea9a-be6e4996fc0d@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=ZdGxk1PBOKOGawhQcLNZeyTj/xo8WHGgfqy1y6yzHoY=;
        b=VPkrR4aAn3aJbX9HSDDpW0USRaDzSdhdN+om9MlIpf6mSMxKE35qtR6HicoM83bMWF
         89aYUdl45Sd9QDTwpOs1ibLUQ0VqCTwOaZnAyXwClrb0QZ3LqHT2DQKNTGE5B0JeCzlw
         xQ06CSwG/XgtL+KBooQLph9KI5KyG3IdZ6tVc6PU/RveF/3awRvdk5p/6qyOHDdjX3GT
         gv4LGYBtF7uptKcEPBwSoE47pJuBGW2azc0j4bCn+Z332aoPAvIzfVn+DrIRIMqnLzFf
         YDR5Zfn0kFCTx9DMfbNdSbbwquq8tvMk73seGGqxATgAE501P6q3vyVnpSJA1VctTYP0
         heFQ==
In-Reply-To: <791880db-bdb0-8d34-ea9a-be6e4996fc0d@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>, shuah@kernel.org, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On Fri, 14 Feb 2020, Mike Kravetz wrote:

> On 2/11/20 1:31 PM, Mina Almasry wrote:
> > Augments hugetlb_cgroup_charge_cgroup to be able to charge hugetlb
> > usage or hugetlb reservation counter.
> > 
> > Adds a new interface to uncharge a hugetlb_cgroup counter via
> > hugetlb_cgroup_uncharge_counter.
> > 
> > Integrates the counter with hugetlb_cgroup, via hugetlb_cgroup_init,
> > hugetlb_cgroup_have_usage, and hugetlb_cgroup_css_offline.
> > 
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > 
> 
> Thanks for the suggested changes.  It will make the code easier to
> read and understand.
> 
> Acked-by: Mike Kravetz <mike.kravetz@oracle.com
> 

Agreed, thanks Mina!

Acked-by: David Rientjes <rientjes@google.com>

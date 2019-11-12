From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHSET cgroup/for-5.5] kernfs,cgroup: support 64bit inos and
 unify cgroup IDs
Date: Tue, 12 Nov 2019 17:08:20 +0100
Message-ID: <20191112160820.GA1685314@kroah.com>
References: <20191104235944.3470866-1-tj@kernel.org>
 <20191112155114.GF4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573574905;
        bh=F7Oqc0NxmF2ZrnvLzaUQ+E39TJo13Hl0CGan0+wgTp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OzFTos7eruaTOsKE5+72Q7SXyMSuITi7cu2SZ4CfLIj4ijcK4cj6dbrsSOAppb/cb
         Zq6QaiB1bFPqt14BKIn2ojvLBPV7IT19ic/k0oN5mpbLVP1IYHWTGvVoYWVJgh1p+7
         GR2k3dw1z4y0xR5ET1oNIKJXtq1FUREH4o109kgI=
Content-Disposition: inline
In-Reply-To: <20191112155114.GF4163745@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net

On Tue, Nov 12, 2019 at 07:51:14AM -0800, Tejun Heo wrote:
> Hello, Greg.
> 
> A gentle ping.  I can route these through cgroup/for-5.5 if you're
> okay with the patch series.

Oops, let me go review...

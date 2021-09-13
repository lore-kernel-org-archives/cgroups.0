From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND] cgroupv2, docs: fix misinformation in "device
 controller" section
Date: Mon, 13 Sep 2021 08:09:05 -1000
Message-ID: <YT+TwTmPEliba601@slm.duckdns.org>
References: <20210908080815.130952-1-arthurchiao@hotmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i1ekjg9yMuKBiH8XeW5HvCgZVasiBrWrygr7iOMv0/w=;
        b=FLD44LaaQn9HDkF4eTXX3iAjKbIr201+F8gAoc3gLLSVcedbAzA++CFkMiEzIhUrjk
         KEMPeoKz0lCQLFx9206No+8jSKhcwXXgFG+ycog5v6v501NW9ZiPlKGg1KvUCSljbESo
         ZJxXIR9hRr9nD7VLNTvnydnFM/CGpeayTchioTqW7W45vsZefKqSQYFr48F1Tdvia16g
         27S1J8VTxZLIPv9bBSL6J7we4V1toTVBwlQCRVkjuGrqOvnPr9uB1HKWimaMtEgD7l4r
         rdQAbkzz/xtOcZw0S5Kb16cNY5qSwwVGLb+fPSDtPa0R8nIksJxQee/lPMY1NHbYq7fy
         PvZw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210908080815.130952-1-arthurchiao@hotmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ArthurChiao <sjtuyananzhao@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, ArthurChiao <arthurchiao@hotmail.com>

On Wed, Sep 08, 2021 at 04:08:15PM +0800, ArthurChiao wrote:
> Hotmail was rejected by the mailing list, switched to gmail to resend.
> 
> 1. Clarify cgroup BPF program type and attach type;
> 2. Fix file path broken.
> 
> Signed-off-by: ArthurChiao <arthurchiao@hotmail.com>

Applied to cgroup/for-5.15-fixes.

Thanks.

-- 
tejun

From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 04/13] blkcg: introduce common blkg association logic
Date: Tue, 27 Nov 2018 16:04:44 -0500
Message-ID: <20181127210443.pornubsaa6vcbgih@macbook-pro-91.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-5-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DKhHMZUmO4T2JI4GxBQQCY43PdHMrucN4JTGGfDXF4A=;
        b=wqUG50DfArZzDI2OENoPA7BlkLdyZFZecJxoqhGbU8JT0QLUgpjFdZ28glcNyCIpJH
         lvr+lLx0UGFkPTk3rpMRBui/6wna+WpJuCEG5yyCTyzthtoEOhkbdpADrH710MDpqA5K
         p41XUCY6XCpQtI+G2GXbRfA5+6BVCxJHcnjN3Q/rjVlm5CdB+aI2uqdadGHA6XJCFdxd
         gqgCWUXPHoFfWikX98jJGDE/DLxV5UJXDHIx8DvkUlWLMsDrD5OebyirJ1GEM7YijMdv
         lT/Xrom2boQMjjaUHykYIVLkke9UJFiPzcPkarS5z2iT+zJE9SP3WgKg8Q0ICAX7SEKZ
         mzmg==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-5-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:37PM -0500, Dennis Zhou wrote:
> There are 3 ways blkg association can happen: association with the
> current css, with the page css (swap), or from the wbc css (writeback).
> 
> This patch handles how association is done for the first case where we
> are associating bsaed on the current css. If there is already a blkg
> associated, the css will be reused and association will be redone as the
> request_queue may have changed.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef

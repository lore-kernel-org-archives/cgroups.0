From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 05/15] blkcg: update blkg_lookup_create to do locking
Date: Fri, 31 Aug 2018 11:37:59 -0400
Message-ID: <20180831153757.ztep3tw5j4zmlatm@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-6-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4horjyeJc+AP18U1mdCUwawf1Q45fUOIo0sacVoEYXQ=;
        b=ZIR6D0IYHg6u+A+5s8aeDh8kd8lRi8BapEmyS73g4N7SiM6QgrZdfo64z1j4F4NZsa
         Y22ROBc/3jomOQ9feMbV9cWEDmdaT3rXFmm9I72rjJfOVrPGc8MM/W3QpP+wFWRK7fTw
         fGEsGrYZ26w6YmTF50Qr24SUZz1rCQNSgwPOAsE3SroC9QVxI4e1/r2H2MYThYuQSz3B
         OM7MU6Z0Fyq6xk/t/jzXyNMQsvcPQ8yI/8oyWy5EnmmyWE7Rr0AvSkYUXtIBRSVvQROr
         KeNmGWK8UsUwBiwVCg/60hlrKh6x0N91ZJ1XDYKbOyKW/sb0g+/YoZ8RWgJydscCXa98
         Y5Sw==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-6-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:46PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> To know when to create a blkg, the general pattern is to do a
> blkg_lookup and if that fails, lock and then do a lookup again and if
> that fails finally create. It doesn't make much sense for everyone who
> wants to do creation to write this themselves.
> 
> This changes blkg_lookup_create to do locking and implement this
> pattern. The old blkg_lookup_create is renamed to __blkg_lookup_create.
> If a call site wants to do its own error handling or already owns the
> queue lock, they can use __blkg_lookup_create.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef

From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] rdmacg: fix a typo in rdmacg documentation
Date: Tue, 23 Oct 2018 12:53:45 -0700
Message-ID: <20181023195345.GB4182586@devbig004.ftw2.facebook.com>
References: <20181023150106.7332-1-ramirose@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kosRG1nnY5WSZUG+c3N8EbuqwT9HCSm5prVMq9msGRA=;
        b=SQRxG2vDrXwE6VzhVF/HxLP0kcVxI6JdLX8gxfs+P4l6IdIzAtLJQGO6dnCRUNDa90
         qCHGA51xR/sYUz//6/6CFvLN8YDkp2e0gn6ru47oaYhEJyJZsZhnqT/mEBtyoOiyJNhb
         dOEvowBEZab+nMBhI4/FV3IrmhHGgz5/VV9AgxPMXmuHqzJCyN/eeXF3MZsZ3EsH9FGO
         xqD9yMTUa+R99BfQPihWNIHytWGCH300r/ll6LYIzwyeqCuiqZOFuqDJnobTPNMnaYJq
         buuUlYkpz6RLS+gjNU7cG41bYjFy9i3fk0WMbpJH/yAlK+bJ8yM0lV8TW8rzUSzyPw2Y
         f/tQ==
Content-Disposition: inline
In-Reply-To: <20181023150106.7332-1-ramirose@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <ramirose@gmail.com>
Cc: pandit.parav@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Tue, Oct 23, 2018 at 06:01:06PM +0300, Rami Rosen wrote:
> This patch fixes a typo in RDMA cgroup documentation.
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied to cgroup/for-4.20.

Thanks.

-- 
tejun

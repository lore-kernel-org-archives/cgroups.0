From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH kselftest-next] Add cgroup core selftests
Date: Thu, 19 Jul 2018 09:57:16 -0700
Message-ID: <20180719165716.GV72677@devbig577.frc2.facebook.com>
References: <20180718173358.14007-1-claudiozumbo@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fCvaMgyC4HO3YmETnpEXZwlnTbwvELCzto9+JxrnNk0=;
        b=DO6pBIBpu2GWN8xrpoOX3KBwCZ0guYrTGStJ6YhCw6QC3C1UROvELXKKv+dYcq1fgs
         qcPx8S1TCUF919wPiFlBUGFrIvoC0C+3xAnE9h00fWfGtYtv2nYN5cLFnww7v/VkpOLq
         YzuRtr4tQzNxIk+C034s9MUaDQyDX9Qc4Pt9gpYlLR3oiTTGfihcYyLDrpHPcZHSUQAn
         YbR5/eyoh+6dGuN23SxzOjwBq+jrUdcgrEjhF7mLc/57a1Aox2jxagXvYyiHxmMV87Ol
         M4Ra2d1xWyiakfYbz7K4571HkUQmHFJPPAJLKIGXnDX6AD8+wJ18RVnWdsWUU7nFgeb3
         HqEw==
Content-Disposition: inline
In-Reply-To: <20180718173358.14007-1-claudiozumbo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Claudio <claudiozumbo@gmail.com>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Claudio Zumbo <claudioz@fb.com>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <guro@fb.com>, kernel-team@fb.com

On Wed, Jul 18, 2018 at 07:33:58PM +0200, Claudio wrote:
> This commit adds tests for some of the core functionalities
> of cgroups v2.
> 
> The commit adds tests for some core principles of croup V2 API:

Acked-by: Tejun Heo <tj@kernel.org>

Thanks, Claudio.

-- 
tejun

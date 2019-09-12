From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroup: freezer: fix frozen state inheritance
Date: Thu, 12 Sep 2019 14:07:05 -0700
Message-ID: <20190912210705.GA3084169@devbig004.ftw2.facebook.com>
References: <20190912175645.2841713-1-guro@fb.com>
 <20190912175645.2841713-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f7nk601YqWAtG+BppI4tPpvttoWT+EaLudF5cFheh38=;
        b=FFrASHQ44NekZUkiYiULB1yPlB5ZHs24EM0JoHbNeivI71UUrRKiW7ppZWKGBNPied
         bzaKmz3jiSogA89RTsOOM9yLSPbJdX53Q1ggBRuLI8J4vtgOH27Qn8kLNr3Su6q0qaHa
         /Gg/NSSaXimEYmKsUqxvPxqilpVF/IF22Fn7CHrzY1gv8Fl/H0yEciDTs6kAAQkOfoxb
         jn8svAHdBHjlfYE2+CRHkdsk7YIhf3XxLBNXtbCw/o5aNFPbKFaAx5CClXf1bF1FbFKO
         bbvAYhE2Yo9NQ73feXQDui0ZKhOtbOKAWhakkZem//Q2Qr2bmCKCtTp/uS7rOaBdYmUd
         NPHQ==
Content-Disposition: inline
In-Reply-To: <20190912175645.2841713-2-guro@fb.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Mark Crossen <mcrossen@fb.com>, stable@vger.kernel.org

Applied 1-2 to cgroup/for-5.3-fixes.

Thanks.

-- 
tejun

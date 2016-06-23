From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup: Disable IRQs while holding css_set_lock
Date: Thu, 23 Jun 2016 17:20:51 -0400
Message-ID: <20160623212051.GM3262@mtj.duckdns.org>
References: <1466627321-22137-1-git-send-email-bristot@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OqbxH4roqv3OlDlGx9L7uzm6MpGMSgrBUMCH+bRk4DY=;
        b=NDGwnAolhTu5ycax2fFJFitVZif3eW8xtfz3f0aOPbnUPnQcQGoLNLx2wuM6PFi/OK
         Iih9l2riPN4aKbL5+K7N02t/g6v/hdOF8JJZwkN0K3XjKEyFXwQl9e6uHKkV34HGxBad
         Y+UKtxRa0UYw1Cuu0RR776MCGUVsfKgy+Nr+vOBcJx8bjZ060gQs5aKTl8P3BGlQvDbq
         46AC2XCQHik9sDz88Hf6YB0Ii1tAZdse2dJlczjMLaC7uZbYBfqUl1NV6m7nkGY+hNvn
         yBm2i49MeCU6/aqGhHXrYv1XbbqhQNhN+vFMCbklwJwver2eRy8xPAbP0ZmaYcJjKoeL
         Y3Xw==
Content-Disposition: inline
In-Reply-To: <1466627321-22137-1-git-send-email-bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis Claudio R. Goncalves" <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied to cgroup/for-4.7-fixes.

Thanks.

-- 
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Fix incomplete dd command.
Date: Mon, 7 Dec 2015 10:29:58 -0500
Message-ID: <20151207152958.GE9175@mtj.duckdns.org>
References: <1449023323-14224-1-git-send-email-sunyuan3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rfUddSoUtqoX/xcbCzecLzELBYZCyhvH+zJ9Ghdlft0=;
        b=Bi2tm2hkCcGZi7+rErgALgQFYqPzuNNGUn6NihjpCNd2ZlAOlQfW6N16oURoL7O5Fk
         0qZpUiMVrcWR7ufwX7fr2bLiFIvesQbokNeHDNsbMMfadh2zTNLAW8qUDJ4h9PsbSRCE
         nFyMrICkKeGjG3WpPUvWxV3jZmJtBc0IhrwMNmz3cWBtj03LKKg7+03aGEX/xn0rpx1M
         k88m9fHx9dNrshnRE6aDEEGPfIuccwidL2nxHpRFQkjTwc2zFzVuJ3QSfftzN5gbunV3
         kxSW+PE3xZ0DRAU3c+aZl/fz/JApEdVPWIW1eSFFKfu91JvTppR8oRjj96a7+uxuOrb0
         skWw==
Content-Disposition: inline
In-Reply-To: <1449023323-14224-1-git-send-email-sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 02, 2015 at 10:28:43AM +0800, Yuan Sun wrote:
> Signed-off-by: Yuan Sun <sunyuan3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.5.

Thanks.

-- 
tejun

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: use helper macro FLUSH_TIME
Date: Sat, 3 Jun 2023 00:36:41 -0700
Message-ID: <CALvZod6Qa5doN7QJAbr+vtPByyqoPoPiOJAdecT7gnO5+AZnNA@mail.gmail.com>
References: <20230603072116.1101690-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685777813; x=1688369813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUND+da6jPiEZt0cfKognqgQRJ86LBwupcOXaX1hrLc=;
        b=VE46kVI2oIPTsZQ3yann7Au1KxFUj1nnFC+18MB5AqtniFnmSHWd1y1BXsjKsUwm+u
         Ozkr1Fu04aLS6kfxawtnRVfdkElUMVB6/BauC46cNNtSjC7P/UA9xEl74ZJP4URW0RND
         rk0Iiykc0ZL5UbkzaajOyqatihTO1jw8jKbx+cJ5xiDrbBA8EYif5JnBmJObGk7icRw4
         NfAwuBlR5lBxPgg4cEw1o4jI9HyazTql6te3QaGXS3SMhj52QcJYxrzji3wa1diaDMML
         iEYaLuhJHi39hiGGgXb1swQjwl7o78WAwN0plU6i6piYAymxjyiR3XTRPKncDXW7ai+2
         x6zA==
In-Reply-To: <20230603072116.1101690-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 3, 2023 at 12:21=E2=80=AFAM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> w=
rote:
>
> Use helper macro FLUSH_TIME to indicate the flush time to improve the
> readability a bit. No functional change intended.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

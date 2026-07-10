Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2652331EC4
	for <cgroups@vger.kernel.org>; Fri, 10 Jul 2026 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783704648; cv=pass; b=qF6uDuMnfA06EgQQi/TGnFrkwY5Xzf7wXVbtLd41rki0KMEUx+oMPu/8YcnJ+BatQ4fq+NVLbHuZAGqt8KvzDv7X2/xyrns3YBgTIYv7aJML4mSGWEkduUs1L+Ao6sLEcbNQgcr9UEcGk9hB69ujTZqYPmgYUA8aW4JXyocCpAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783704648; c=relaxed/simple;
	bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c9E6TjV3D2giNolt8c07fprxXJ4P8Ko760R6rwO1n4xfNJVPM9L4qaC21hBysNYoADVMGgPZ8TbzrQJKkhEP8Bb9Iw47X4lTek2dLkEhrBpPyxKuUfNHHDXAgvM0zb6CcjyU4DMk+q8wFfzfOT47e3XClH8psqqNNlcP90HxKMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sud/MdKw; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sud/MdKw"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4798bea72f9so673931f8f.1
        for <cgroups@vger.kernel.org>; Fri, 10 Jul 2026 10:30:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783704641; cv=none;
        d=google.com; s=arc-20260327;
        b=ptZHG8fAndb1yNjDPah1X1z+eAw1lzH54T3n8iPz7In5bTAQDZgFCezoJFn3nmQTeO
         sq3Knp4YWRaqciN6JJAh4ajtZXpBXv04d674lu3hWn8Ddxong35sxe8gQfECvBBeMc2a
         MN96Q5WGdWZ3tgOPUtZEpPNd7GiwfVm6J0DvcVlzrXj26fi5uaGA2xTHBwwGyayKMCKz
         qxsFhh/4vtHE60pRqIidVKazQm9R/8MfhqSEdk+1JvF05+tb6q+s52xzSn2W+JFZqdrK
         1JvlEAgcF34QMkpQyko9p+gFe5905Q910fK3DZgoQdfp7gt/gVJDVXEuMnKif2PPb138
         CuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
        fh=ClYqTO0kcbWebTQ3ilpEMaHcW50ZOMh2aye9lVeeOms=;
        b=Eh0J5TfiJPR1kB3AlrWANsy2Ytz+pg9DFFSVImlWsKByd0uD760/84FcKDHL/JmFM9
         MjpJXjPN697pr+ozEbQxCXKS944XWkf75ShTUOa62Wg3kRjqv9PN7ZIoqBMnOI14c/rP
         hUXtuUawuAIl38WEoc/lYwDpttSRpiM7Qzcn+DSwRNJotPGpMlJlDl9KqDYh0kmC1Htq
         sheSh5t5LpwOG839vbq+ufD5EatWU4hZNtQMhEG0ekW0tOtUd29Jlcv7BkP7jvsGBect
         vgi/C58B4JNcIShExNnE6koardMfuMucNfuhvAp89DjnlxOxfiukQh6VxRsRvJBVlLvx
         ym2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783704641; x=1784309441; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
        b=Sud/MdKwBO3/uo+uCB4GlvVspHekxy8IYFzuVkmQjWxrl3tRlQBSG+VVp0+PAkA4ff
         CwDZ49MBL3z/YNzl1qkm5J+041iRF1LfMTJo6hkWzvaZhUL6aIo1yjE8rs3Zq/EhUkBo
         /UFdJ3WoBRnhgs1fPSbLr9M2NqdnMVudoNdQfZpUM6P7WpwyZRYt4fTMwUIVFGnBLuEU
         Fv1wAwBZOhGpX2HJYILO8QVtbxZJEQKnqEoJ6Ds+obT99xKEhLVGYzO/V4NRwBX0Fb/z
         oHz6necV8WfCFDksDA/u1EEXULxXOWsMJfQI9h5hH+p+DzbuH2w5cYlyzdbCIurwHsmi
         GNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783704641; x=1784309441;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WP7giIq6JORl1AU1d3jmZFpFIM0XkPQ7s5H7vFgoW3A=;
        b=exYTZz4bodFhh0XohLcQL/EHBunk4Z0P1Oki/6PIaofCzwvxlkd382IY8GjaGrm/Cv
         qbsEaWRJh5BHfWNK5uplwQ6whWgBZ0ozYUCTBSz1eoRl/iUgpFBW00K5HhI8njJa8jHW
         eUmsPhonN7zYjS85BeBjiKanwJmvIPeztzgC4G7fQ1cakRpkti7NPQQ5/RNo/YBLkFct
         OR+1/H1pYB9OyzdSi06kvvM4qsVhfkmfCwe6mUZosYVoDve8/g5Su58P4xAdykA4zV3B
         VBvQOFkA+TV/wmH+WBMZuAVHAFz54ZdnzgsmlQt20o3ftcNBKXAZtVbsYLrq9xd6JF2m
         TkCw==
X-Forwarded-Encrypted: i=1; AHgh+Roh0RhBXXqqes5hmpDgS9e1iWELsuiU+VAFQbRFaA7kz+jPEzC5xMm6kh6y5BaflxjwkohMk+vd@vger.kernel.org
X-Gm-Message-State: AOJu0YwyYbgwIry4hlcD3wQHmUnll/Q7040ugX9jsz00PIKrU605+HG9
	NMUNV7sa4P/0NlvkYoHoKGgoorAWUFRS3oYERctGV3t1ObdLHWwI5aHosNR3VMUrVxQog+DW2jY
	zYq9W/6M1VAQ7y65HY4xQzomqflOlTMg=
X-Gm-Gg: AfdE7clmjR1sstnhkXQoSgzM/oIizMcmZWZcHv0FXMJtXWZZ8/Up33ZmFU7X/gUP/Qw
	YwIH3v1UT2PvzH94MOuh+X8OE/sLLQTyjKCOmZGcg8QqSV04INFiQps35ioi6zokoh+2QTzkpsn
	CE+42jMR4vxrymQpO8TRekb638vqXtqyvrSKRoUAgOUC9GvPoq6tTFtYwlcDFc5cP130jc4EsgQ
	U5f38AAdwZg+M1dYVGk3IeUIUTPiE2zKoadAgzE7TRCAQRfpIE1OO6oPvhja2W5/rgPAlAifjmU
	1csZjpCB/mjEBjk2UeqlBoMPnjPHjuY7gFAWpK0=
X-Received: by 2002:a5d:64c8:0:b0:47f:2bce:6f38 with SMTP id
 ffacd0b85a97d-47f2bce71f2mr1605932f8f.28.1783704641136; Fri, 10 Jul 2026
 10:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
 <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
 <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com>
 <ak6c2TaOlcGxZ2Ih@localhost.localdomain> <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
In-Reply-To: <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 10 Jul 2026 10:30:28 -0700
X-Gm-Features: AUfX_mwd51QhDhOxXEqljZbVmcwLnRoGIaPgZBSLTfEB8WOHhjbjcuIKoDcPaYY
Message-ID: <CAKEwX=PLauANTu8nDLbDmViQ6u9gvh7HbKffUAzUXuBa6Jes=g@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Yosry Ahmed <yosry@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 12:08=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Wed, Jul 8, 2026 at 12:00=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.=
com> wrote:
> >
> > On Tue, Jul 07, 2026 at 02:49:56PM -0700, Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > I would honestly rather use more memory. I think there might be cases
> > > where the flusher is delayed. The flush being slightly delayed is not
> > > technically a bug that we want to see a failure for, but if a large
> > > stats change is not visible that's a user-noticeable behavior that we
> > > want a failure for.
> > >
> > > WDYT?
> >
> > There's already the (recent) page size-based scaling, so the idea with
> > nr_cpus scaling could make the selftest useful on wider range of setups
> > (even page size can be considered as a slight implementation detail
> > leak, thus the justification of nr_cpus dependency).
> >
> > Also, I still think that internally the threshold should be changed to
> > the "harmonic" formula [1] but the selftest can go with the linear
> > dependency for more pronounced effects.
>
> Yeah I agree the threshold formula can be improved, but we need to
> make sure performance doesn't regress.

Yeah that's a separate discussion indeed. For now I'm fine with fixing
the selftests by using more memory.

Is there a good generic formula for this? I understand there will be
hardcode values, but at least making it scalable (by how much memory
we have, page size, # of cpus) if possible? :)

Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF30D55D86D
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791997715; cv=none; b=mVk+Dd5fazS/oMOSpQFUL9ZdVMvEMXUZL3z4iWYfuZdS3YTkED3CHNMU6P5PgLRCGmUtPcO8fxzbvzYDeHtP+2/uV1D3/WDGAge5mTH+iuUOA3phpq5DIYvrhuIzX0L27oitR9+ED4AZ2BQPHd7kIYeh1cdqHgk5GnroW6FIR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791997715; c=relaxed/simple;
	bh=18W50nwXyn7U9V9smq16pS1vshVmIOIZSXwkdv6O84U=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=nYc808VVsm/lEtnNr7gEKAV2iZVvv+Krolzct7i+Sq1b+hU0W1VrE1J15T6XQiOZ593px+STXnqpt+bjdhSkxdx3IwnECVTiH0JephIjohl404OP7KW9kyQ56tQBVL1XKAHc1UN614gOl62UgLUR+09h5iGkxkvs32tsvV9xqeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nV/mfdtJ; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=or+c5gIa; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nV/mfdtJ";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="or+c5gIa"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EGYQgA2812322
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=OQYG6p9/H5SkzSVfBEy5FmiFS3
	xl893haPgmkNoad14=; b=nV/mfdtJwsdyFL48fZCD7ZGmuZMxwCLeQp5SnLo8Lr
	A8cRDwhYtsFiFAuQH7Ikk92CodAg8WQbgLRqQIk9zKPliDx4C7eYsoB1ByrV25l9
	Zuqhcq682ARPB/qBej31x9aKOdCqPUZG3Z6FzuxWoR/NbU6B6BqFcqw8hw8Mhs9D
	5U1XLcFU1S3YVZJ/S/+nT69vmXHjnM/oaptBGwYGodNSgGKFmBsorxJIDAKgAMB8
	NTSMs5lRFcvLLmrWkN9QPGoC/iLWQZCg5vxbghngY4GJrVx+qo0gS8Dy3ZripYyK
	0LNlWWx15nphWJ9OOzmyG8AjLAp1YTmBAEM0siUe07qg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ha6c7bqr9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 13:08:27 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93dd3c3badbso135238485a.2
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 10:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791997707; x=1792602507; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OQYG6p9/H5SkzSVfBEy5FmiFS3xl893haPgmkNoad14=;
        b=or+c5gIamyljDiOyxH93vFwlH1nrM+BZB+/X2PiTLGWBpIpHkQN+38MYf78lSwQvtK
         KUdfkG/GyfsJkRndfnDpLZ7Azrz31qdIxTMlLPXPbZyGVLy28M49b0orjB6W4fW8AP57
         +ZsqMWECpxT8dxMjXFXe54ukYbSD6GKgsfWEa6dDNjrY0dZHkK5Np0H3QluCf8rrh0pt
         iYGJvY2B1bGiAPdZkI3y/5ylamappJC38O+Ow3KK7xpB615c67Y3vBbyUIEJd+i0mkoE
         yRjL43ssJIbQC7aptKcCC2WTfFsJfoir/Sx2LmgG8mcFpfKOIDrDA+CELIMN11c/xYIm
         HkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791997707; x=1792602507;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OQYG6p9/H5SkzSVfBEy5FmiFS3xl893haPgmkNoad14=;
        b=ltVRjon/JlBTw4UlMKpIfqyYDPHoig2sb2syC3gtS6Px7NObOeasSA+CWVsGvkDXvO
         PWHQGcpIbXSDoxbDT7gOeGRcSnrn2ZFGPwTj9kGeacpmXKHlLaeIstATmQIp+pP6lKeS
         d8DPBJFUMDa6T167VdLOCwiWiWjUhPw3lf7LkRuRBpeK7OX0IEUotCexsy5HBOtk0nHG
         5qRnl5aVP+ZwL6hBxYXipMcl2QWOT7T/kv6X7jZkQTnj1MkvhBMJ0RJK53Mth5FWVTS1
         /hONhN5V29wlH6Q8i71a8UM5EEx/XjTVZD2DsFK1BuRtPcb9DJzDqgSq+fmDKOteAlKk
         K3dA==
X-Gm-Message-State: AFq9FYJuBSTbaQsMlmcIrdqFFDwudIytQG5lvWFVu0ZJ2ng0KAJ8FnBD
	slzhinuPhjXRETB6/JC8y+Bybu9Z0k87BMAondLt1hQoMtaJ+HLIjcrq6TkXsknM84+MKKQPyvh
	eZ8hPYWIDhARSEqBlsshUhww96rDHW5KoTFkGYrhvZgXASzl0l+vG2EU=
X-Gm-Gg: AYBFou0psK9gHf+7BX9zfgAZcd+76BwkkoUnZrdm18I7vn72VIoSpBroCkUKp78dXEh
	zgKyjXN5/0AlKqiVjEG68ByynnozqxlnL4RXP0pBXK8UkwJuF4jdUB93c7keK3Yvs4Iw5WW9U3b
	FR3OTe6ZlKCiNpgTX9qy8gxPYrIhmSZhsnLlw7IW+YWPFkrcTH0R4DuPXG2ZaaaO8Yb/sEbSfEv
	vaorE1MVCkYCNULE787l/u3vi8Q9jsTXHPzAMiq4hmPlSNJ1NBGkz+JXl4tX4f1qiVuWp/YoD6l
	pDOVI6AvYegqxroXKftoL5OMtcgyGM41JDbX9rQ1Wrr+o8CuCSSyLOXI35g2nFZUtzp+sAgNHy7
	lC8FLtrBfxRLyqLaauCg2wDFTA//5T/a6eJYmQOI4187jWL4=
X-Received: by 2002:a05:620a:2a10:b0:93e:c12c:9b71 with SMTP id af79cd13be357-93ec12c9ef0mr2595929485a.76.1791997706799;
        Wed, 14 Oct 2026 10:08:26 -0700 (PDT)
X-Received: by 2002:a05:620a:2a10:b0:93e:c12c:9b71 with SMTP id af79cd13be357-93ec12c9ef0mr2595924185a.76.1791997706379;
        Wed, 14 Oct 2026 10:08:26 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-148.net.columbia.edu. [128.59.176.148])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b9bda8643sm49190116d6.25.2026.10.14.10.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:08:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/2] mm: memcontrol: remove two unused helpers
Date: Wed, 14 Oct 2026 13:08:19 -0400
Message-Id: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAO3z2oC/yXMUQrCMBCE4auUfXYhaUsQryI+pOnYrtgYso0Ip
 Xdv1McPZv6NFFmgdGk2yniLyitW2FNDYfZxAstYTa1pnTW25wVLmLjEohg5+TqY8UzIyqHv/Nk
 5wAye6j9l3OXza19vf2sZHgjrN0j7fgBGmuYZfQAAAA==
X-Change-ID: 20261014-memcg-unused-page-helpers-c43a866ee0ba
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791997705; l=474;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=18W50nwXyn7U9V9smq16pS1vshVmIOIZSXwkdv6O84U=;
 b=2aHeCLrlYlAv92xitm4F6gmPMcrkqJ1s19K+DNpvY47RTbxe5YJ+Y3C7BUgCYLBnYmZyOL5E8
 6o1NOqbqvThBeksuqYPHhAjtt0c+kANVTXW9anNm+a6Yw7hFwcwN4+Q
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: HSpRyjPCRHOjZ16xM4opgKvrawexAGEV
X-Authority-Analysis: v=2.4 cv=G/CJgNk5 c=1 sm=1 tr=0 ts=6acfb70b cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=dxtdfZqDOO0kCslK4e47hQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=YtfsaVvi3jZCfUEAq8QA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX4mA7omdPRNnO
 E7DE1DdftZE6cfTA799NneZ1bjDc+JOozgyG/pIsCc5C9VKEg2+CUHWtNNXE28BzKvNzDHvMIEn
 sWkJGUDGjHhKvdl4DuX/930dKjszM2uG3Rh4fJOfenfYFoOxtu3c
X-Proofpoint-GUID: HSpRyjPCRHOjZ16xM4opgKvrawexAGEV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA2OCBTYWx0ZWRfX8S2E3TIAxumS
 DQFw3zWf9fbT/bJ3mOwXw96y5pR3uV/gl0bGv1vtOxpLc8siCBdJJCloklP9rZ6mJsvfYtbiQOj
 tv17QAiTp470JfHh3n2KOFV3Fp48qHk8C41sFQ40obj6sVropoe4d2vCj2703qbmlQ5EMfwp5GQ
 WmlxsHb4Z+YNnb2mCcOcZ+R5zPKQSnhDZoeHqhhOO5EYlEU4CIH1amKQJPBdv5JguKTOo90VZrf
 e2KM7R782SHUU08o56bGWF5rNwoYXflj1xNpUonvP4HSzzHKaANOv4UB9GKLH1+T6dM4rXii9CV
 tZAt+R/fSITFJ0olZr0FI/KJ8kItdFsvjbiNQBQa8HhanjajdAt6v3wg64TPwDY4oJxxTnJ5gDY
 pcpjzFiKIOHUA+hfIFbDsvBbqLw8whpqaH4xR8WWCEpgKKLDLfP5EzwnoNN3IsTz+yipifJ/Jgz
 ZeE9dpA17Kpf375C9VQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11935
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 bulkscore=10 lowpriorityscore=10 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140068

They were happily unused until I decided to disturb their peace.

---
Tal Zussman (2):
      mm: memcontrol: remove mod_memcg_page_state()
      mm: memcontrol: remove page_memcg_check()

 include/linux/memcontrol.h | 32 --------------------------------
 1 file changed, 32 deletions(-)
---
base-commit: ad9f2d463666c64e94b04be5263c9bf8f9f96fb7
change-id: 20261014-memcg-unused-page-helpers-c43a866ee0ba

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


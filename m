Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E301863
	for <cgroups@vger.kernel.org>; Tue, 24 Oct 2023 02:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 579 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Oct 2023 19:55:40 PDT
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C058E120
	for <cgroups@vger.kernel.org>; Mon, 23 Oct 2023 19:55:40 -0700 (PDT)
Received: from imladris.home.surriel.com ([10.0.13.28] helo=imladris.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.1)
	(envelope-from <riel@shelob.surriel.com>)
	id 1qv7QJ-0003Ej-0b;
	Mon, 23 Oct 2023 22:45:39 -0400
Message-ID: <c47d47c45176f0a703b7d7d4725078b607411c17.camel@surriel.com>
Subject: Re: [PATCH] selftests: add a sanity check for zswap
From: Rik van Riel <riel@surriel.com>
To: Nhat Pham <nphamcs@gmail.com>, shuah@kernel.org
Cc: hannes@cmpxchg.org, cerasuolodomenico@gmail.com, tj@kernel.org, 
	lizefan.x@bytedance.com, linux-mm@kvack.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Date: Mon, 23 Oct 2023 22:45:39 -0400
In-Reply-To: <20231020222009.2358953-1-nphamcs@gmail.com>
References: <20231020222009.2358953-1-nphamcs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Sender: riel@surriel.com

On Fri, 2023-10-20 at 15:20 -0700, Nhat Pham wrote:
>=20
> This test add a sanity check that ensure zswap storing works as
> intended.
>=20
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
>=20

Acked-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.
